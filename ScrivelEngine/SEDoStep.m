//
//  SEDoStep.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEDoStep.h"

@implementation SEDoStep

- (instancetype)initWithName:(NSString *)name arguments:(NSDictionary *)arguments
{
    self = [self init];
    _arguments = arguments;
    _name = name;
    return self;
}

@end
