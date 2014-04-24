//
//  SEAnimationStep.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEAnimationStep.h"

@implementation SEAnimationStep

- (instancetype)initWithArguments:(NSDictionary *)arguments
{
    self = [self init];
    // 振り分ける
    self.toKeyValues = arguments;
    _duration = [arguments[@"in"] doubleValue];
    _reverse = [arguments[@"reverse"] boolValue];
    return self;
}

@end
