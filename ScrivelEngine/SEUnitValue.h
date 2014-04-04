//
//  SEUnitNumber.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SEUnitType){
    SEUnitTypeDefault,
    SEUnitTypePixels,
    SEUnitTypePercentage,
    SEUnitTypeVirtualPixels
};

@interface SEUnitValue : NSObject

/**
 "10"   -> 10.0, SEUnitTypeDefault
 "10px" -> 10.0, SEUnitTypePixel
 "10%"  -> 10.0, SEUnitTypePercentage
 "10vpx"-> 10.0, SEUnitTypeVirtualPixels
 **/
+ (instancetype)unitNumberWithValueDescription:(NSString*)valueDscription;
+ (instancetype)unitNumberWithCGFloat:(CGFloat)CGFloat unitType:(SEUnitType)unitType;

@property (nonatomic, readonly) SEUnitType unitType;
@property (nonatomic, readonly) NSNumber *numberValue;

- (instancetype)initWithValueDescription:(NSString*)valueDescription;
- (CGFloat)CGFloatValueWithConstraint:(CGFloat)constraint;

@end
