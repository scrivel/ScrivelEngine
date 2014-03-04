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
#import "SEMethod.h"
#import "SEMethodChain.h"
#import "SEWords.h"
#import "SEClassProxy.h"
#import "NSObject+KXEventEmitter.h"

static NSArray *engineClassses;
NSString *const SEWaitBeganEvent = @"org.scrivel.ScrivelEngine:SEWaitBeganEvent";
NSString *const SEWaitCompletionEvent = @"org.scrivel.ScrivelEngine:SEWaitCompleteEvent";
NSString *const SEAnimationCompletionEvent = @"org.scrivel.ScrivelEngine:SEAnimationCompleteEvent";
NSString *const SETextDisplayCompletionEvent = @"org.scrivel.ScrivelEngine:SETextDisplayCompletionEvent";

@implementation ScrivelEngine
{
    Queue *_elementQueue;
    Queue *_methodQueue;
}

@synthesize classProxy = _classProxy;
@synthesize isWaiting = _isWaiting;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engineClassses = @[@"app",@"layer",@"text"];//,@"bgm",@"se",@"ui",@"chara"];
    });
}

+ (instancetype)engineWithRootView:(SEView*)rootView
{
    return [[self alloc] initWithRootView:rootView];
}

- (id)init
{
    self = [super init];
    [self setClassProxy:[SEBasicClassProxy new]];
    _methodQueue = [Queue new];
    _elementQueue = [Queue new];
    return self ?: nil;
}

- (id)initWithRootView:(SEView*)rootView
{
    self = [self init];
    _rootView = rootView;
    return self ?: nil;
}

- (id)evaluateScript:(NSString *)script error:(NSError *__autoreleasing *)error
{
    SEScript *s = [SEScript scriptWithString:script error:error];
    if (*error) {
        return NO;
    }
    return [self enqueueScript:s];
}

- (id)enqueueScript:(id)sender
{
    _isWaiting = NO;
    id returnValue = nil;
    __weak typeof(self) __self = self;
    [self kx_once:SEWaitBeganEvent handler:^(NSNotification *n) {
        [__self setValue:@YES forKey:@"_isWaiting"];
        [__self kx_once:SEWaitCompletionEvent handler:^(NSNotification *n) {
            [__self enqueueScript:nil];
        }];
    }];
    if ([sender isKindOfClass:[SEScript class]]){
        // エレメントをキューイング
        [_elementQueue enqueueObjects:[(SEScript*)sender elements]];
    }
    // 前回のイベントループで途中だったメソッドを実行する
    SEMethod *method;
    while (!self.isWaiting && (method = [_methodQueue dequeue]) != nil) {
        returnValue = [method call];
    }
    // 溜まっているエレメントを順番に処理していく
    SEElement *element;
    while (!self.isWaiting && (element = [_elementQueue dequeue]) != nil) {
        if ([element isKindOfClass:[SEMethodChain class]]) {
            SEMethodChain *chain = (SEMethodChain*)element;
            // staticメソッドを実行
            NSString *classID = chain.targetClass;
            id<SEObjectClass> class = [self valueForKey:[NSString stringWithFormat:@"_%@",classID]];
            SEMethod *m = [chain.methods objectAtIndex:0];
            id<SEObjectInstance> instance = [class callMethod_method:m];
            // インスタンスのメソッドチェーンを実行
            for (NSUInteger i = 1; i < chain.methods.count; i++) {
                m = [chain.methods objectAtIndex:i];
                // wait中でなければ実行
                if (!self.isWaiting) {
                    returnValue = [instance callMethod_method:m];
                }else{
                    // 次回のイベントループにキューイングする
                    m.target = instance;
                    [_methodQueue enqueue:m];
                } 
            }
        }else if([element isKindOfClass:[SEWords class]]){
            SEWords *words = (SEWords*)element;
            if (words.name) {
                SEMethod *name_m = [[SEMethod alloc] initWithName:@"setName" lineNumer:words.rangeOfLines.location];
                name_m.arguments = @[words.name];
                returnValue = [self.text callMethod_method:name_m];
            }
            if (words.text) {
                SEMethod *text_m = [[SEMethod alloc] initWithName:@"setText" lineNumer:words.rangeOfLines.location+1];
                text_m.arguments = @[words.text];
                returnValue = [self.text callMethod_method:text_m];
            }
            // タップを待つ処理をキューイングする
            [self kx_once:SEWaitCompletionEvent handler:^(NSNotification *n) {
                [__self.app waitTap];
                [__self kx_once:SEWaitCompletionEvent handler:^(NSNotification *n) {
                    [__self enqueueScript:nil];
                }];
            }];
        }else{
            // value
            return element;
        }
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
            if (![_classProxy classForClassIdentifier:chain.targetClass]) {
                NSMutableString *ms = [NSMutableString stringWithString:@"!!存在しないクラスです!!\n"];
                [ms appendFormat:@"line\t\t:\t%@\n",NSStringFromRange(chain.rangeOfLines)];
                [ms appendFormat:@"class\t:\t%@\n",chain.targetClass];
                NSDictionary *ui = @{ NSLocalizedDescriptionKey : ms};
                *error = [NSError errorWithDomain:@"" code:0 userInfo:ui];
                return NO;
            }
            for (SEMethod *method in chain) {
                if (![_classProxy selectorForMethodIdentifier:method.name classIdentifier:chain.targetClass]
                    && ![[(SEBasicApp*)self.app aliasStore] objectForKey:method.name]) {
                    NSString *type = (method == [chain.methods firstObject]) ? @"static" : @"instance";
                    NSMutableString *ms = [NSMutableString stringWithString:@"!!存在しないメソッドの呼び出しです!!\n"];
                    [ms appendFormat:@"line\t\t:\t%@\n",NSStringFromRange(chain.rangeOfLines)];
                    [ms appendFormat:@"class\t:\t%@\n",chain.targetClass];
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

- (void)setClassProxy:(id<SEClassProxy>)classProxy
{
    if (_classProxy != classProxy) {
        _classProxy = classProxy;
        // classProxyに対して内部のクラスオブジェクトを作成
        for (NSString *className in engineClassses) {
            Class<NSObject,SEObjectClass> class = [classProxy classForClassIdentifier:className];
            id<SEObjectClass> c = [objc_msgSend(class, @selector(alloc)) initWithEngine:self classIdentifier:className];
            // layer -> _layer
            if (c) {
                [self setValue:c forKey:[NSString stringWithFormat:@"_%@",className]];
            }
        }
    }
}

@end
