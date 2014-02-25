//
//  ScrivelEngine.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
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
            id<SEObjectInstance> instance = [class callStatic_method:m];
            if (instance) {
                // チェーンを実行
                returnValue = instance;
                while ((m = [chain dequeueMethod]) != nil) {
                    returnValue = [instance callInstance_method:m];
                }
            }
        }else{
            // value
            return element;
        }
    }
    return returnValue;
}

- (void)setClassProxy:(id<SEClassProxy>)classProxy
{
    if (_classProxy != classProxy) {
        _classProxy = classProxy;
        // classProxyに対して内部のクラスオブジェクトを作成
        for (NSString *className in engineClassses) {
            Class<NSObject,SEObjectClass> class = [classProxy classForClassIdentifier:className];
            id<SEObjectClass> c = [objc_msgSend(class, @selector(alloc)) initWithEngine:self];
            // layer -> _layer
            if (c) {
                [self setValue:c forKey:[NSString stringWithFormat:@"_%@",className]];
            }
        }
    }
}

@end
