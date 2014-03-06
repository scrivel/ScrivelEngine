
//
//  _SEConcretObject.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicObject.h"
#import "ScrivelEngine.h"
#import "SEMethod.h"
#import "SEClassProxy.h"
#import <objc/message.h>
#import "SEBasicApp.h"

#define SAME_TYPE(s1,s2) ((strcmp(s1,s2) == 0) ? YES : NO)


id callMethod(id target, NSString *class, SEMethod *method, ScrivelEngine *engine)
{
    // SEMethodを動的に呼び出す
    // aliasを探す
    NSString *name = [[(SEBasicObjectClass*)target aliasStore] objectForKey:method.name] ?: method.name;
    SEL sel = [engine.classProxy selectorForMethodIdentifier:name classIdentifier:class];
    // wait系メソッドをappにフォワーディングする
    if ([method.name hasPrefix:@"wait"]) {
        target = engine.app;
        sel = [engine.classProxy selectorForMethodIdentifier:method.name classIdentifier:@"app"];
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
        __unsafe_unretained id retval = nil;
        [iv getReturnValue:&retval];
        return retval ?: nil;
    }
}

@implementation _SEObject
{
    NSMutableDictionary *__keyValueStore;
    NSMutableDictionary *__enabledStore;
    NSMutableDictionary *__aliasStore;
}

@synthesize keyValueStore = __keyValueStore;
@synthesize enabledStore = _enabledStore;
@synthesize aliasStore = __aliasStore;

- (id)init
{
    self = [super init];
    __keyValueStore = [NSMutableDictionary new];
    __enabledStore = [NSMutableDictionary new];
    __aliasStore = [NSMutableDictionary new];
    return self ?: nil;
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

@end

@implementation SEBasicObjectClass
{
    NSHashTable *__instances;
}

- (instancetype)initWithEngine:(ScrivelEngine *)engine classIdentifier:(NSString *)classIdentifier
{
    self = [self init];
    _engine = engine;
    _classIdentifier = classIdentifier;
    __instances = [NSHashTable weakObjectsHashTable];
    _instanceClass = [SEBasicObjectClass class];
    return self ?: nil;
}

- (id)callMethod_method:(SEMethod *)method
{
    return callMethod(self, self.classIdentifier, method, self.engine);
}

- (id)new_args:(id)args
{
    SEBasicObject *new = [[self.instanceClass alloc] initWithOpts:args holder:self];
    // インスタンスを弱参照で保持する（必要かな？）
    [__instances addObject:new];
    return new;
}

@end

@implementation SEBasicObject

- (instancetype)initWithOpts:(NSDictionary *)options holder:(SEBasicObjectClass *)holder
{
    self = [self init];
    _holder = holder;
    return self ?: nil;
}

#pragma mark - SEObject


- (id)callMethod_method:(SEMethod *)method
{
    return callMethod(self, self.holder.classIdentifier, method, self.holder.engine);
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    // ダメそうだったらappにフォワーディングする
    return self.holder.engine.app;
}


@end

