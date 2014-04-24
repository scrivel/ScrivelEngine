//
//  SEWaitStep.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEWaitStep.h"

@implementation SEWaitStep

- (instancetype)initWithWaitIdentifier:(id)waitIdentifier
{
    self = [self init];
    if ([waitIdentifier isKindOfClass:[NSString class]]) {
        if ([waitIdentifier isEqualToString:@"tap"]) {
            _waitStepType = SEWaitStepTypeTap;
        }else if ([waitIdentifier isEqualToString:@"animation"]){
            _waitStepType = SEWaitStepTypeAnimation;
        }else if ([waitIdentifier isEqualToString:@"text"]){
            _waitStepType = SEWaitStepTypeText;
        }
    }else if ([waitIdentifier isKindOfClass:[NSNumber class]]){
        _waitStepType = SEWaitStepTypeDuration;
        _duration = [waitIdentifier doubleValue];
    }
    return self;
}

@end
