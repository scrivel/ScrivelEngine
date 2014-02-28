//
//  NSNumber+CGFloat.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/26.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "NSNumber+CGFloat.h"

@implementation NSNumber (CGFloat)

- (CGFloat)CGFloatValue
{
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}

@end
