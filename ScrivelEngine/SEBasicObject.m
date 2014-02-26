
//
//  _SEConcretObject.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicObject.h"
#import "ScrivelEngine.h"
#import "SEMethod.h"
#import <objc/message.h>

#define SAME_TYPE(s1,s2) ((strcmp(s1,s2) == 0) ? YES : NO)

static id callMethod(id target, SEMethod *method, ScrivelEngine *engine)
{
    // SEMethodを動的に呼び出す
    SEL sel = [engine.classProxy selectorForMethodIdentifier:method.name];
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


@implementation SEBasicObjectClass
{
    NSHashTable *__instances;
}

- (instancetype)initWithEngine:(ScrivelEngine *)engine
{
    self = [self init];
    _engine = engine;
    __instances = [NSHashTable weakObjectsHashTable];
    _instanceClass = [SEBasicObjectClass class];
    return self ?: nil;
}

- (id)callStatic_method:(SEMethod *)method
{
    return callMethod(self, method, self.engine);
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


- (id)callInstance_method:(SEMethod *)method
{
    return callMethod(self, method, self.holder.engine);
}


@end

