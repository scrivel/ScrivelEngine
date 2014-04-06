//
//  SEGeometory.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/05
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEGeometory.h"

inline SEUnitValue * SEUnitValueMake(id obj)
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [SEUnitValue unitNumberWithCGFloat:[obj CGFloatValue] unitType:SEUnitTypeDefault];
    }else if ([obj isKindOfClass:[NSString class]]){
        return [SEUnitValue unitNumberWithValueDescription:obj];
    }else if ([obj isKindOfClass:[SEUnitValue class]]){
        return obj;
    }
    return nil;
}

inline CGFloat SEMakeX(CGFloat constraint, SEUnitValue *f)
{
    return [f CGFloatValueWithConstraint:constraint];
}

inline CGFloat SEMakeY(CGFloat constraint, SEUnitValue *f)
{
    CGFloat y = [f CGFloatValueWithConstraint:constraint];
#if TARGET_OS_IPHONE
    return constraint - y;
#else
    return y;
#endif
}

inline CGPoint CGPointFromObject(id obj)
{
    if ([obj isKindOfClass:[NSArray class]]) {
        return CGPointMake([obj[0] CGFloatValue], [obj[1] CGFloatValue]);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return CGPointMake([obj[@"x"] CGFloatValue], [obj[@"y"] CGFloatValue]);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_pointValue];
    }
    return CGPointZero;
}

inline SESize SESizeMake(SESize constraintSize, id w , id h)
{
    SEUnitValue *_w = SEUnitValueMake(w);
    SEUnitValue *_h = SEUnitValueMake(h);
    return CGSizeMake([_w CGFloatValueWithConstraint:constraintSize.width],
                      [_h CGFloatValueWithConstraint:constraintSize.height]);
}

inline SEPoint SEPointMake(SESize constraintSize, id x, id y)
{
    SEUnitValue *_x = SEUnitValueMake(x);
    SEUnitValue *_y = SEUnitValueMake(y);
    return CGPointMake(SEMakeX(constraintSize.width, _x), SEMakeY(constraintSize.height, _y));
}

inline SERect SERectMake(SESize constraintSize, id x, id y, id w, id h)
{
    SEUnitValue *_x = SEUnitValueMake(x);
    SEUnitValue *_y = SEUnitValueMake(y);
    SEUnitValue *_w = SEUnitValueMake(w);
    SEUnitValue *_h = SEUnitValueMake(h);
    return CGRectMake(SEMakeX(constraintSize.width, _x),
                      SEMakeY(constraintSize.height, _y),
                      [_w CGFloatValueWithConstraint:constraintSize.width],
                      [_h CGFloatValueWithConstraint:constraintSize.height]);
}

inline SEVector SEVectorMake(SESize constraintSize, id dx, id dy)
{
    SEUnitValue *_x = SEUnitValueMake(dx);
    SEUnitValue *_y = SEUnitValueMake(dy);
#if TARGET_OS_IPHONE
    _y = [SEUnitValue unitNumberWithCGFloat:-_y.numberValue.CGFloatValue unitType:_y.unitType];
#endif
    SEVector v;
    v.dx = [_x CGFloatValueWithConstraint:constraintSize.width];
    v.dy = [_y CGFloatValueWithConstraint:constraintSize.height];
    return v;
}

inline SESize SESizeFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    return SESizeMake(constraintSize, x, y);
}

inline SESize SESizeFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitValue *w = SEUnitValueMake(dictionary[@"width"]);
    SEUnitValue *h = SEUnitValueMake(dictionary[@"height"]);
    return SESizeMake(constraintSize, w, h);
}

inline SESize SESizeFromObject(SESize constraintSize, id obj)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SESizeFromArray(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SESizeFromDictionary(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_sizeValue];
    }
    return CGSizeZero;
}

inline SEPoint SEPointFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    return SEPointMake(constraintSize, x, y);
}

inline SEPoint SEPointFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitValue *x = SEUnitValueMake(dictionary[@"x"]);
    SEUnitValue *y = SEUnitValueMake(dictionary[@"y"]);
    return SEPointMake(constraintSize, x, y);
}

inline SEPoint SEPointFromObject(SESize constraintSize, id obj)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SEPointFromArray(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SEPointFromDictionary(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_pointValue];
    }
    return CGPointZero;
}

inline SEVector SEVectorFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    return SEVectorMake(constraintSize, x, y);
}

inline SEVector SEVectorFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitValue *dx = SEUnitValueMake(dictionary[@"dx"]);
    SEUnitValue *dy = SEUnitValueMake(dictionary[@"dy"]);
    return SEVectorMake(constraintSize, dx, dy);
}

inline SEVector SEVectorFromObject(SESize constraintSize, id obj)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SEVectorFromArray(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SEVectorFromDictionary(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_vectorValue];
    }
    SEVector v;
    v.dx = 0;
    v.dy = 0;
    return v;
}

inline SERect SERectFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    SEUnitValue *w = SEUnitValueMake(array[2]);
    SEUnitValue *h = SEUnitValueMake(array[3]);
    return SERectMake(constraintSize, x, y, w, h);
}

inline SERect SERectFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitValue *x = SEUnitValueMake(dictionary[@"x"]);
    SEUnitValue *y = SEUnitValueMake(dictionary[@"y"]);
    SEUnitValue *w = SEUnitValueMake(dictionary[@"width"]);
    SEUnitValue *h = SEUnitValueMake(dictionary[@"height"]);
    return SERectMake(constraintSize, x, y, w, h);
}

inline SERect SERectFromObject(SESize constraintSize, id obj)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SERectFromArray(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SERectFromDictionary(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_rectValue];
    }
    return CGRectZero;
}


inline SEEdgeInsets SEEdgeInsetsFromArray(SESize constraintSize, NSArray *array)
{
    CGFloat top = [[SEUnitValueMake(array[0]) numberValue] CGFloatValue];
    CGFloat left = [[SEUnitValueMake(array[1]) numberValue] CGFloatValue];
    CGFloat bottom = [[SEUnitValueMake(array[2]) numberValue] CGFloatValue];
    CGFloat right = [[SEUnitValueMake(array[3]) numberValue] CGFloatValue];
    return SEEdgeInsetsMake(top, left, bottom, right);
}

inline SEEdgeInsets SEEdgeInsetsFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    CGFloat top = [[SEUnitValueMake(dictionary[@"top"]) numberValue] CGFloatValue];
    CGFloat left = [[SEUnitValueMake(dictionary[@"left"]) numberValue] CGFloatValue];
    CGFloat bottom = [[SEUnitValueMake(dictionary[@"bottom"]) numberValue] CGFloatValue];
    CGFloat right = [[SEUnitValueMake(dictionary[@"right"]) numberValue] CGFloatValue];
    return SEEdgeInsetsMake(top, left, bottom, right);
}

inline SEEdgeInsets SEEdgeInsetsFromObject(SESize constraintSize, id obj)
{
    if ([obj isKindOfClass:[NSArray class]]) {
        return SEEdgeInsetsFromArray(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SEEdgeInsetsFromDictionary(constraintSize, obj);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_edgeInsetsValue];
    }
    return SEEdgeInsetsMake(0, 0, 0, 0);
}

inline CGFloat SEMakeRadian (CGFloat degree)
{
#if TARGET_OS_IPHONE
    return -(CGFloat)(degree*(M_PI/180.0f));
#else
    return (CGFloat)(degree*(M_PI/180.0f));
#endif
}
inline CGFloat SENormalize(CGFloat f)
{
    CGFloat _f = ROUND_CGFLOAT(f);
    if (_f < 0) {
        return 0.0;
    }else if (_f > 1){
        return 1.0;
    }
    return _f;
}
