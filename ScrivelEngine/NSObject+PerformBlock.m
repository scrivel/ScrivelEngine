//
//  NSObject+PerformBlock.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/06.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "NSObject+PerformBlock.h"

@implementation NSObject (PerformBlock)

- (void)se_executeBlock:(void (^)(void))block
{
    if (block) block();
}
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)afterDelay
{
    [self performSelector:@selector(se_executeBlock:) withObject:[block copy] afterDelay:afterDelay];
}

@end
