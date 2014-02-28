//
//  NSValue+ScrivelEngine.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"

@interface NSValue (ScrivelEngine)

+ (instancetype)se_valueWithPoint:(SEPoint)point;
+ (instancetype)se_valueWithRect:(SERect)rect;
+ (instancetype)se_ValueWithSize:(SESize)size;

@end
