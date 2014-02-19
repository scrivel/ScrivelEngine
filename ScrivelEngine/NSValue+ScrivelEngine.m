//
//  NSValue+ScrivelEngine.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "NSValue+ScrivelEngine.h"

@implementation NSValue (ScrivelEngine)

+ (instancetype)se_valueWithPoint:(SEPoint)point
{
#if TARGET_OS_IPHONE
    return [NSValue valueWithCGPoint:point];
#elif TARGET_OS_MAC
    return [NSValue valueWithPoint:point];
#endif
}

+ (instancetype)se_valueWithRect:(SERect)rect
{
#if TARGET_OS_IPHONE
    return [NSValue valueWithCGRect:rect];
#elif TARGET_OS_MAC
    return [NSValue valueWithRect:rect];
#endif
}

+ (instancetype)se_ValueWithSize:(SESize)size
{
#if TARGET_OS_IPHONE
    return [NSValue valueWithCGSize:size];
#elif TARGET_OS_MAC
    return [NSValue valueWithSize:size];
#endif
}

@end
