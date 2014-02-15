//
//  SEMethodChain.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethodChain.h"

@implementation SEMethodChain
{
    NSMutableArray *__methods;
}

- (id)init
{
    self = [super init];
    __methods = [NSMutableArray new];
    return self ?: nil;
}

- (id)call
{
    return nil;
}

- (void)addMethod:(SEMethod *)method
{
    [__methods addObject:method];
}

- (NSArray *)methods
{
    return __methods;
}

@end
