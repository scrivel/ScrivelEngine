//
//  NSValue+ScrivelEngine.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SETypeDefinition.h"

@interface NSValue (ScrivelEngine)

+ (instancetype)se_valueWithPoint:(SEPoint)point;
+ (instancetype)se_valueWithRect:(SERect)rect;
+ (instancetype)se_valueWithSize:(SESize)size;
+ (instancetype)se_valueWithVector:(SEVector)vector;
+ (instancetype)se_valueWithEdgeInsets:(SEEdgeInsets)insets;
- (SESize)se_sizeValue;
- (SEPoint)se_pointValue;
- (SEVector)se_vectorValue;
- (SERect)se_rectValue;
- (SEEdgeInsets)se_edgeInsetsValue;

@end
