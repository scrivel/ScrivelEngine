//
//  SEElement.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"

@implementation SEElement

- (instancetype)initWithLineNumber:(NSUInteger)lineNumber
{
    self = [self init];
    _lineNumber = lineNumber;
    return self ?: nil;
}

@end
