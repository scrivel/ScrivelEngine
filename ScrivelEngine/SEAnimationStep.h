//
//  SEAnimationStep.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SESetStep.h"

@interface SEAnimationStep : SESetStep

- (instancetype)initWithArguments:(NSDictionary*)arguments;

@property (nonatomic) CFTimeInterval duration;
@property (nonatomic) NSDictionary *options;
@property (nonatomic) BOOL reverse;

@end
