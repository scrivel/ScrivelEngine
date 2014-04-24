//
//  SEUnitPoint.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEUnitPoint.h"

@implementation SEUnitPoint

+ (instancetype)pointWithX:(SEUnitValue *)x y:(SEUnitValue *)y
{
    return [[self alloc] initWithX:x y:y];
}

- (instancetype)initWithX:(SEUnitValue *)x y:(SEUnitValue *)y
{
    self = [self init];
    _x = x;
    _y = y;
    return self;
}

@end
