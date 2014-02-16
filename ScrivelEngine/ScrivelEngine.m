//
//  ScrivelEngine.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "ScrivelEngine.h"

static ScrivelEngine *shared;

@implementation ScrivelEngine

+ (instancetype)sharedEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (SEClassProxy *)classProxy
{
    if (!_classProxy) {
        _classProxy = [SEClassProxy new];
    }
    return _classProxy;
}

@end
