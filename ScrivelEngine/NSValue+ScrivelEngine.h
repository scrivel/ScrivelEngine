//
//  NSValue+ScrivelEngine.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
typedef CGPoint SEPoint;
typedef CGRect SERect;
typedef CGSize SESize;
#elif TARGET_OS_MAC
typedef NSPoint SEPoint;
typedef NSRect SERect;
typedef NSSize SESize;
#endif


@interface NSValue (ScrivelEngine)

+ (instancetype)se_valueWithPoint:(SEPoint)point;
+ (instancetype)se_valueWithRect:(SERect)rect;
+ (instancetype)se_ValueWithSize:(SESize)size;

@end
