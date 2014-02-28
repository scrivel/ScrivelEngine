//
//  SEAnimationOperation.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/28.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEAnimationOperation : NSOperation

+ (instancetype)animationOperationWithTarget:(CALayer*)target animation:(CAAnimation*)animation;

@property (nonatomic, weak) CALayer *target;
@property (nonatomic) CAAnimation *animation;
@property (nonatomic, copy) NSString *animationKey;

@end
