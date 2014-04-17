//
//  _SEObject.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/05.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "_SEObject.h"
#import "SEMethod.h"
#import "SEClassProxy.h"
#import <objc/message.h>
#import "SEBasicApp.h"

#define SAME_TYPE(s1,s2) ((strcmp(s1,s2) == 0) ? YES : NO)

id se_callMethod(id target, NSString *class, SEMethod *method, ScrivelEngine *engine)
{
    NSLog(@"evaluating : %@.%@",class,method.name);
    // SEMethodを動的に呼び出す
    // aliasを探す
    __unsafe_unretained id retval = nil;
    // デバッグ中はクラッシュさせる
#if !DEBUG
    @try {
#endif
        NSString *name = [[(SEBasicObjectClass*)target aliasStore] objectForKey:method.name] ?: method.name;
        SEL sel = [engine.classProxy selectorForMethodIdentifier:name classIdentifier:class];
        if ([method.name hasPrefix:@"wait"]) {
            // wait系メソッドをappにフォワーディングする
            target = engine.app;
            sel = [engine.classProxy selectorForMethodIdentifier:method.name classIdentifier:@"app"];
        }else if ([method.name isEqualToString:@"set"]){
            // setメソッドだけはargumentsをそのまま引数に渡す
            NSString *key = [method argAtIndex:0];
            NSArray *values = [method.arguments subarrayWithRange:NSMakeRange(1, method.arguments.count-1)];
            if (values.count == 1) {
                [(_SEObject*)target set_key:key value:values[0]];
            }else if (values.count > 1){
                [(_SEObject*)target set_key:key value:values];
            }
            return nil;
        }
        NSMethodSignature *sig = [target methodSignatureForSelector:sel];
        NSInvocation *iv = [NSInvocation invocationWithMethodSignature:sig];
        [iv setTarget:target];
        [iv setSelector:sel];
        [iv retainArguments];
        for (NSUInteger i = 0; i < sig.numberOfArguments - 2; i++) {
            // シグネチャのargの型によって安全に引数を渡す
            // 現状、原則としてint, unsinedなどのCプリミティブ型は引数にはしない
            const char * type = [sig getArgumentTypeAtIndex:i+2];
            if (SAME_TYPE(type, @encode(NSUInteger))) {
                NSUInteger uintarg = (NSUInteger)[method unsignedIntegerArtAtIndex:i];
                [iv setArgument:&uintarg atIndex:i+2];
            }else if (SAME_TYPE(type, @encode(NSInteger))){
                NSInteger intarg = [method integerArgAtIndex:i];
                [iv setArgument:&intarg atIndex:i+2];
            }else if (SAME_TYPE(type, @encode(CGFloat))){
                CGFloat cgfArg = [method CGFloatArgAtIndex:i];
                [iv setArgument:&cgfArg atIndex:i+2];
            }else if (SAME_TYPE(type, @encode(NSTimeInterval))){
                NSTimeInterval doubleArg = [method doubleArgAtIndex:i];
                [iv setArgument:&doubleArg atIndex:i+2];
            }else if (SAME_TYPE(type, @encode(BOOL))){
                BOOL boolArg = [method boolArgAtIndex:i];
                [iv setArgument:&boolArg atIndex:i+2];
            }else{
                id arg = nil;
                arg = [method argAtIndex:i];
                [iv setArgument:&arg atIndex:i+2];
            }
        }
        [iv invoke];
        if (SAME_TYPE([sig methodReturnType], @encode(void))) {
            return target;
        }else{
            [iv getReturnValue:&retval];
        }
#if !DEBUG
    }
    @catch (NSException *exception) {
        NSLog(@"could not call method '%@' for class '%@' : %@",method.name, class, exception);
        @throw exception;
    }
    @finally {
    }
#endif
    return retval ?: nil;
}

@implementation _SEObject
{
    NSMutableDictionary *__keyValueStore;
    NSMutableDictionary *__enabledStore;
    NSMutableDictionary *__aliasStore;
}

@synthesize keyValueStore = __keyValueStore;
@synthesize enabledStore = __enabledStore;
@synthesize aliasStore = __aliasStore;

- (id)init
{
    self = [super init];
    __keyValueStore = [NSMutableDictionary new];
    __enabledStore = [NSMutableDictionary new];
    __aliasStore = [NSMutableDictionary new];
    return self ?: nil;
}

- (void)dealloc
{
    
}

- (instancetype)initWithEngine:(ScrivelEngine *)engine
{
    _engine = engine;
    self = [self init];
    return self;
}

- (id)callMethod_method:(SEMethod *)method
{
    // override
    NSAssert(NO, @"!!NEEDS OVERRIDE!!");
    return nil;
}

- (void)set_key:(NSString *)key value:(id)value
{
    if (key && value != nil && value != [NSNull null]) {
        [__keyValueStore setObject:value forKey:key];
    }
}

- (void)enable_key:(NSString *)key enable:(BOOL)enable
{
    if (key) {
        [__enabledStore setObject:@(enable) forKey:key];
    }
}

- (void)alias_alias:(NSString *)alias method:(NSString *)method
{
    // wa -> waitAnimation
    [__aliasStore setObject:method forKey:alias];
}

- (BOOL)respondsToKey:(NSString *)key
{
    return NO;
}

- (BOOL)canEnableForKey:(NSString *)key
{
    return NO;
}

- (BOOL)canAliasizeForKey:(NSString *)key
{
    return NO;
}

@end
