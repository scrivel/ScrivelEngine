//
//  ScrivelEngine.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "ScrivelEngine.h"
#import <objc/message.h>
#import "SEObject.h"
#import "SEScript.h"
#import "SEBasicClassProxy.h"
#import "SEBasicApp.h"
#import "SEBasicLayer.h"
#import "SEBasicTextLayer.h"
#import "SEBasicCharacterLayer.h"
#import "SEMethod.h"
#import "SEMethodChain.h"
#import "SEWords.h"
#import "SEClassProxy.h"
#import "NSObject+KXEventEmitter.h"
#import "Queue.h"

NSString *const SEWaitBeganEvent = @"org.scrivel.ScrivelEngine:SEWaitBeganEvent";
NSString *const SEWaitCompletionEvent = @"org.scrivel.ScrivelEngine:SEWaitCompleteEvent";
NSString *const SETimeoutCompletionEvent = @"org.scrivel.ScrivelEngine:SETimeoutCompletionEvent";
NSString *const SETapCompletionEvent = @"org.scrivel.ScrivelEngine:SETapCompleteEvent";
NSString *const SEAnimationCompletionEvent = @"org.scrivel.ScrivelEngine:SEAnimationCompleteEvent";
NSString *const SETextDisplayCompletionEvent = @"org.scrivel.ScrivelEngine:SETextDisplayCompletionEvent";
NSString *const SEStateChangedEvent = @"org.scrivel.SEStateChangedEvent";
NSString *const SEStateChangedEventStateKey = @"org.scrivel.SEStateChangedEventStateKey";

@interface ScrivelEngine ()

@property (nonatomic, readwrite) ScrivelEngineState state;
@property (nonatomic, readwrite) BOOL isWaiting;

- (BOOL)shouldRunScript;

@end

@implementation ScrivelEngine
{
    SEBasicApp *__app;
    SEBasicLayerClass *__layer;
    SEBasicTextLayerClass *__text;
    SEBasicCharacterLayerClass *__chara;
}

@synthesize app = __app;
@synthesize layer = __layer;
@synthesize text = __text;
@synthesize chara = __chara;
@synthesize virtualSize = _virtualSize;

+ (instancetype)engineWithWindow:(SEWindow *)window rootView:(SEView *)rootView
{
    return [[self alloc] initWithWindow:window rootView:rootView];
}

- (id)init
{
    self = [super init];
    self.classProxy = [SEBasicClassProxy new];
    _taskQueue = [Queue new];
    _identifier = [[NSUUID UUID] UUIDString];
    _state = ScrivelEngineStateIdle;
    _speed = 1.0f;
    _virtualSize = CGSizeZero;
    _notificationCenter = [NSNotificationCenter new];
    _baseURL = nil;
    return self ?: nil;
}

- (id)initWithWindow:(SEWindow*)window rootView:(SEView*)rootView
{
    self = [self init];
    self.window = window;
    self.rootView = rootView;
    return self ?: nil;
}

- (void)dealloc
{
    [self kx_offCenter:self.notificationCenter];
}

#pragma mark - Setter

- (void)setRootView:(SEView *)rootView
{
    if (rootView != _rootView) {
#if SE_TARGET_OS_MAC
        rootView.wantsLayer = YES;
#endif
        [__app setUpTapRecognizerWithView:rootView];
        _rootView = rootView;
    }
}

- (void)setClassProxy:(id<SEClassProxy>)classProxy
{
    if (_classProxy != classProxy) {
        _classProxy = classProxy;
        // classProxyに対して内部のクラスオブジェクトを作成
        __app = [[[classProxy classForClassIdentifier:@"app"] alloc] initWithEngine:self classIdentifier:@"app"];
        __layer = [[[classProxy classForClassIdentifier:@"layer"] alloc] initWithEngine:self classIdentifier:@"layer"];
        __chara = [[[classProxy classForClassIdentifier:@"chara"] alloc] initWithEngine:self classIdentifier:@"chara"];
        __text = [[[classProxy classForClassIdentifier:@"text"] alloc] initWithEngine:self classIdentifier:@"text"];
    }
}

- (void)setState:(ScrivelEngineState)state
{
    if (_state != state) {
        [self kx_emit:SEStateChangedEvent
             userInfo:@{SEStateChangedEventStateKey: @(state)}
               center:self.notificationCenter];
        _state = state;
    }
}

- (SESize)virtualSize
{
    if (CGSizeEqualToSize(_virtualSize, CGSizeZero)) {
        return self.rootView.bounds.size;
    }else{
        return _virtualSize;
    }
}

#pragma mark - Interface

- (void)pause
{
    self.state = ScrivelEngineStatePaused;
}

- (void)resume
{
    self.state = ScrivelEngineStateRunning;
}

- (void)clear
{
    [self.layer clearAll];
    [self.chara clearAll];
    [self.text clearAll];
    [_taskQueue clear];
    self.state = ScrivelEngineStateIdle;
}

- (BOOL)shouldRunScript
{
    return !self.isWaiting && self.state == ScrivelEngineStateRunning;
}

- (id)evaluateScript:(NSString *)script error:(NSError *__autoreleasing *)error
{
    SEScript *s = [SEScript scriptWithString:script error:error];
    if (*error) {
        return NO;
    }
    return [self enqueueScript:s prior:NO];
}

- (id)enqueueScript:(SEScript*)sender prior:(BOOL)prior
{
    self.isWaiting = NO;
    self.state = ScrivelEngineStateRunning;
    id returnValue = nil;
    // waitが発生した場合のコールバック
    __weak typeof(self) __self = self;
    [self kx_once:SEWaitBeganEvent handler:^(NSNotification *n) {
        __self.isWaiting = YES;
        // waitの終了を待ってリトライする
        [__self kx_once:SEWaitCompletionEvent handler:^(NSNotification *n) {
            [__self enqueueScript:nil prior:NO];
        } from:nil center:__self.notificationCenter];
    } from:nil center:self.notificationCenter];
    // senderがSEScriptの場合 => 通常のキューイング
    if ([sender isKindOfClass:[SEScript class]]){
        // priorの場合は割り込みさせる
        if (prior) {
            [_taskQueue enqueueObjects:[(SEScript*)sender elements] prior:YES];
        }else{
            // エレメントをキューイング
            [_taskQueue enqueueObjects:[(SEScript*)sender elements]];
        }
    }
    // 溜まっているタスクを順番に処理していく
    id task;
    while ([self shouldRunScript] && (task = [_taskQueue dequeue]) != nil) {
        if ([task isKindOfClass:[SEMethod class]]) {
            returnValue = [(SEMethod*)task call];
        }else if ([task isKindOfClass:[SEMethodChain class]]) {
            SEMethodChain *chain = (SEMethodChain*)task;
            id<SEObjectInstance> instance;
            SEMethod *m;
            // staticメソッドを実行
            switch (chain.type) {
                case SEMethodChainTypeNormal: {
                    // 通常のメソッドチェーン
                    id<SEObjectClass> class = [self valueForKey:[NSString stringWithFormat:@"__%@",chain.target]];
                    m = [chain.methods objectAtIndex:0];
                    instance = [class callMethod_method:m];
                }
                    break;
                case SEMethodChainTypeCharacterSpecified:{
                    // {"なまえ"}.method()のようなキャラクターに対するメソッド呼び出し
                    instance = [__chara.layers objectForKey:chain.target];
                }
                    break;
                default:
                    break;
            }
            // インスタンスのメソッドチェーンを実行
            NSUInteger i = (chain.type == SEMethodChainTypeNormal) ? 1 : 0;
            for (; i < chain.methods.count; i++) {
                m = [chain.methods objectAtIndex:i];
                // wait中でなければ実行
                if ([self shouldRunScript]) {
                    returnValue = [instance callMethod_method:m];
                }else{
                    // 次回のイベントループにキューイングする
                    m.target = instance;
                    [_taskQueue enqueue:m];
                }
            }
        }else if([task isKindOfClass:[SEWords class]]){
            SEWords *words = (SEWords*)task;
            if (words.character) {
                [__text.primaryNameLayer setText_text:words.character noanimate:YES];
            }
            if (words.text) {
                [__text.primaryTextLayer setText_text:words.text noanimate:NO];
            }
            // タップを待つ処理をキューイングする
            [self.app waitText];
            [self kx_once:SETapCompletionEvent handler:^(NSNotification *n) {
                if (__text.primaryTextLayer.isAnimating) [__text.primaryTextLayer skip];
            } from:nil center:self.notificationCenter];
            [self kx_once:SEWaitCompletionEvent handler:^(NSNotification *n) {
                [__self kx_off:SETapCompletionEvent center:__self.notificationCenter];
                [__self.app waitTap];
                [__self kx_once:SEWaitCompletionEvent handler:^(NSNotification *n) {
                    [__self enqueueScript:nil prior:NO];
                } from:nil center:__self.notificationCenter];
            } from:nil center:self.notificationCenter];
        }else{
            // value
            return task;
        }
    }
    // キューを消化し終わったらアイドルに戻す
    if (_taskQueue.count == 0) {
        self.state = ScrivelEngineStateIdle;
    }
    return returnValue;
}

- (BOOL)validateScript:(NSString *)script error:(NSError *__autoreleasing *)error
{
    /*
     チェック項目
     - そもそもparseに失敗してないか
     - 未定義なクラスが使われていないか
     - 未定義なメソッドが使われていないか
     - 引数の数、型が間違っていないか
     */
    SEScript *s = [SEScript scriptWithString:script error:error];
    if (*error) {
        return NO;
    }
    for (SEElement *element in s.elements) {
        if ([element isKindOfClass:[SEMethodChain class]]) {
            SEMethodChain *chain = (SEMethodChain*)element;
            if (chain.type == SEMethodChainTypeNormal && ![self.classProxy classForClassIdentifier:chain.target]) {
                NSMutableString *ms = [NSMutableString stringWithString:@"!!存在しないクラスです!!\n"];
                [ms appendFormat:@"line\t\t:\t%@\n",NSStringFromRange(chain.rangeOfLines)];
                [ms appendFormat:@"class\t:\t%@\n",chain.target];
                NSDictionary *ui = @{ NSLocalizedDescriptionKey : ms};
                *error = [NSError errorWithDomain:@"" code:0 userInfo:ui];
                return NO;
            }
            for (SEMethod *method in chain) {
                NSString *cid = chain.target;
                if (chain.type == SEMethodChainTypeCharacterSpecified) {
                    cid = @"chara";
                }
                if (![self.classProxy selectorForMethodIdentifier:method.name classIdentifier:cid]
                    && ![[(SEBasicApp*)self.app aliasStore] objectForKey:method.name]) {
                    NSString *type = (method == [chain.methods firstObject]) ? @"static" : @"instance";
                    NSMutableString *ms = [NSMutableString stringWithString:@"!!存在しないメソッドの呼び出しです!!\n"];
                    [ms appendFormat:@"line\t\t:\t%@\n",NSStringFromRange(chain.rangeOfLines)];
                    [ms appendFormat:@"class\t:\t%@\n",chain.target];
                    [ms appendFormat:@"type\t:\t%@\n",type];
                    [ms appendFormat:@"name\t:\t%@",method.name];
                    NSDictionary *ui = @{ NSLocalizedDescriptionKey: ms };
                    *error = [NSError errorWithDomain:@"" code:0 userInfo:ui];
                    return NO;
                }
                // 本当はここで引数の数と型のチェックをしたいけどあとでやる
            }
        }
    }
    return YES;
}

- (CFTimeInterval)convertDuration:(CFTimeInterval)duration
{
#warning #22のための仮対応
    return duration;
    if (self.speed == ScrivelEngineSppedNoWait) {
        return 0;
    }else if(self.speed > 0){
        return duration/self.speed;
    }
    return 0;
}

- (NSString *)pathForResource:(NSString *)path
{
    if (_baseURL) {
        return [[NSURL URLWithString:path relativeToURL:self.baseURL] path];
    }
    return [[NSBundle mainBundle] pathForResource:path ofType:nil];
}

@end
