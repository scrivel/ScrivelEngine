//
//  SEWaitStep.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEStep.h"

typedef NS_ENUM(NSUInteger, SEWaitStepType)
{
    SEWaitStepTypeDuration,
    SEWaitStepTypeTap,
    SEWaitStepTypeAnimation,
    SEWaitStepTypeText
};

@interface SEWaitStep : SEStep

- (instancetype)initWithWaitIdentifier:(id)waitIdentifier;

// waitの種類
@property (nonatomic) SEWaitStepType waitStepType;
// Durationの場合、時間
@property (nonatomic) CFTimeInterval duration;
// Durationの場合、経過時間
@property (nonatomic) CFTimeInterval elapsedTime;

@end
