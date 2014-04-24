//
//  SEUnitPoint.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEUnitPoint : NSObject

+ (instancetype)pointWithX:(SEUnitValue*)x y:(SEUnitValue*)y;

@property (nonatomic, readonly) SEUnitValue *x;
@property (nonatomic, readonly) SEUnitValue *y;


@end
