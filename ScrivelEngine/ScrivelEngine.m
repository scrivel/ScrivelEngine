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

static NSArray *engineClassses;

@implementation ScrivelEngine

@synthesize classProxy = _classProxy;

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
    id returnValue = nil;
    if (*error) {
        return NO;
    }
    for (id element in s.elements) {
        if ([element isKindOfClass:[SEMethodChain class]]) {
            //　メソッドチェーンを実行
            SEMethodChain *chain = (SEMethodChain*)element;
            // layer, bgなどのクラスへの参照の場合
            // 対応するクラスオブジェクトを取得
            NSString *classID = chain.targetClass;
            id<SEObjectClass> class = [self valueForKey:[NSString stringWithFormat:@"_%@",classID]];
            // 最初は静的メソッド
            SEMethod *m = [chain dequeueMethod];
            id<SEObjectInstance> instance = [class callMethod_method:m];
            if (instance) {
                // チェーンを実行
                returnValue = instance;
                while ((m = [chain dequeueMethod]) != nil) {
                    returnValue = [instance callMethod_method:m];
                }
            }
        }else if([element isKindOfClass:[SEWords class]]){
            SEWords *words = (SEWords*)element;
            if (words.name) {
                SEMethod *name_m = [[SEMethod alloc] initWithName:@"setName" type:SEMethodTypeCall lineNumer:words.rangeOfLines.location];
                name_m.arguments = @[words.name];
                returnValue = [self.text callMethod_method:name_m];
            }
            if (words.text) {
                SEMethod *text_m = [[SEMethod alloc] initWithName:@"setText" type:SEMethodTypeCall lineNumer:words.rangeOfLines.location+1];
                text_m.arguments = @[words.text];
                returnValue = [self.text callMethod_method:text_m];
            }
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
                if (![_classProxy selectorForMethodIdentifier:method.name classIdentifier:chain.targetClass]) {
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
