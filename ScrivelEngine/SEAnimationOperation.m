//
//  SEAnimationOperation.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/28.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEAnimationOperation.h"

@implementation SEAnimationOperation
{
    BOOL isFinished;
    BOOL isExecuting;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"isFinished"]
        || [key isEqualToString:@"isExecuting"]) {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

+ (instancetype)animationOperationWithTarget:(CALayer *)target animation:(CAAnimation *)animation
{
    return [[self alloc] initWithTarget:target animation:animation];
}

- (id)initWithTarget:(CALayer*)target animation:(CAAnimation *)animation
{
    self = [self init];
    _target = target;
    _animation = animation;
    return self ?: nil;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isFinished
{
    return isFinished;
}

- (BOOL)isExecuting
{
    return isExecuting;
}

- (void)start
{
    isFinished = NO;
    isExecuting = YES;    
    [CATransaction begin];
    __block __weak typeof (self) __self = self;
    [CATransaction setCompletionBlock:^{
        [__self setValue:@YES forKey:@"isFinished"];
        [__self setValue:@NO forKey:@"isExecuting"];
    }];
    [self.target addAnimation:self.animation forKey:self.animationKey];
    [CATransaction commit];
}

@end
