
//
//  _SEConcretObject.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicObject.h"


@implementation SEBasicObjectClass
{
    NSHashTable *__instances;
}

- (instancetype)initWithEngine:(ScrivelEngine *)engine classIdentifier:(NSString *)classIdentifier
{
    self = [super initWithEngine:engine];
    _classIdentifier = classIdentifier;
    __instances = [NSHashTable weakObjectsHashTable];
    return self ?: nil;
}

- (Class)instanceClass
{
    return [SEBasicObjectClass class];
}

- (id)callMethod_method:(SEMethod *)method
{
    return se_callMethod(self, self.classIdentifier, method, self.engine);
}

- (id)new_args:(id)args
{
    SEBasicObject *new = [[self.instanceClass alloc] initWithOpts:args holder:self];
    // インスタンスを弱参照で保持する（必要かな？）
    [__instances addObject:new];
    //
    [args enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [new set_key:key value:obj];
    }];
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

- (ScrivelEngine *)engine
{
    return self.holder.engine;
}

#pragma mark - SEObject


- (id)callMethod_method:(SEMethod *)method
{
    return se_callMethod(self, self.holder.classIdentifier, method, self.holder.engine);
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    // ダメそうだったらappにフォワーディングする
    return self.holder.engine.app;
}


@end

