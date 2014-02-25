
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
        const char * type = [sig getArgumentTypeAtIndex:i+2];
        if (SAME_TYPE(type, @encode(NSUInteger))) {
            NSUInteger uintarg = (NSUInteger)[method unsignedIntegerArtAtIndex:i];
            [iv setArgument:&uintarg atIndex:i+2];
        }else if (SAME_TYPE(type, @encode(NSInteger))){
            NSInteger intarg = [method integerArgAtIndex:i];
            [iv setArgument:&intarg atIndex:i+2];
        }else if (SAME_TYPE(type, @encode(CGFloat))){
            CGFloat doubArg = [method doubleArgAtIndex:i];
            [iv setArgument:&doubArg atIndex:i+2];
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
    NSMutableSet *__instances;
}

- (instancetype)initWithEngine:(ScrivelEngine *)engine
{
    self = [self init];
    _engine = engine;
    __instances = [NSMutableSet new];
    _instanceClass = [SEBasicObjectClass class];
    return self ?: nil;
}

- (id)callStatic_method:(SEMethod *)method
{
    return callMethod(self, method, self.engine);
}

- (id)new_args:(id)args
{
    SEBasicObject *new = [[self.instanceClass alloc] initWithOpts:args];
    // インスタンスを保持
    new.holder = self;
    [__instances addObject:new];
    return new;
}

@end

@implementation SEBasicObject

- (instancetype)initWithOpts:(NSDictionary *)options
{
    self = [self init];
    return self ?: nil;
}

#pragma mark - SEObject


- (id)callInstance_method:(SEMethod *)method
{
    return callMethod(self, method, self.holder.engine);
}


@end

