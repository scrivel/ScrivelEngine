//
//  SEUnitSize.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEUnitSize : NSObject

+ (instancetype)sizeWithWidth:(SEUnitValue*)width height:(SEUnitValue*)height;

@property (nonatomic, readonly) SEUnitValue *width;
@property (nonatomic, readonly) SEUnitValue *height;

@end
