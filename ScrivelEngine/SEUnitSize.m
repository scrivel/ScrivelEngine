//
//  SEUnitSize.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEUnitSize.h"

@implementation SEUnitSize

+ (instancetype)sizeWithWidth:(SEUnitValue *)width height:(SEUnitValue *)height
{
    return [[self alloc] initWithWidth:width height:height];
}

- (instancetype)initWithWidth:(SEUnitValue *)width height:(SEUnitValue *)height
{
    self = [self init];
    _width = width;
    _height = height;
    return self;
}

@end
