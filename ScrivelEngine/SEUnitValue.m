//
//  SEUnitNumber.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEUnitValue.h"
#import "NSNumber+CGFloat.h"

@implementation SEUnitValue

static inline NSString * getUnitString(SEUnitType type)
{
    switch (type) {
        case SEUnitTypeDefault:
            return @"";
        case SEUnitTypePixels:
            return @"px";
        case SEUnitTypePercentage:
            return @"%";
        case SEUnitTypeVirtualPixels:
            return @"vpx";
        default:
            break;
    }
    return @"";
}

+ (instancetype)unitNumberWithValueDescription:(NSString *)valueDscription
{
    return [[self alloc] initWithValueDescription:valueDscription];
}

+ (instancetype)unitNumberWithCGFloat:(CGFloat)CGFloat unitType:(SEUnitType)unitType
{
    return [[self alloc] initWithValueDescription:[NSString stringWithFormat:@"%f%@",CGFloat,getUnitString(unitType)]];
}

- (instancetype)initWithValueDescription:(NSString *)valueDscription
{
    self = [self init];
    NSError *e = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\-?\\d+\\.?(\\d+)?)" options:0 error:&e];
    NSTextCheckingResult *result = [regex firstMatchInString:valueDscription options:0 range:NSMakeRange(0, valueDscription.length)];
    float float_v =  [[valueDscription substringWithRange:[result rangeAtIndex:1]] floatValue];
    _numberValue = [NSNumber numberWithFloat:float_v];
    if ([valueDscription hasSuffix:@"vpx"]) {
        _unitType = SEUnitTypeVirtualPixels;
    }else if ([valueDscription hasSuffix:@"px"]){
        _unitType = SEUnitTypePixels;
    }else if ([valueDscription hasSuffix:@"%"]){
        _unitType = SEUnitTypePercentage;
    }else{
        _unitType = SEUnitTypeDefault;
    }
    return self ?: nil;
}

- (CGFloat)CGFloatValueWithConstraint:(CGFloat)constraint
{
    switch (self.unitType) {
        case SEUnitTypePixels:
        case SEUnitTypeDefault:
            return self.numberValue.CGFloatValue;
        case SEUnitTypePercentage:
            return (CGFloat)constraint*(self.numberValue.CGFloatValue/100);
        case SEUnitTypeVirtualPixels:
            // 仮想サイズが320pxだった場合
        default:
            break;
    }
    return 0;
}

@end
