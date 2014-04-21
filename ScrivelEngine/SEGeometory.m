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

inline CGFloat SEMakeX(SEUnitValue *f, CGFloat constraint, CGFloat virtualConstraint)
{
    return [f CGFloatValueWithConstraint:constraint virtualConstraint:virtualConstraint];
}

inline CGFloat SEMakeY(SEUnitValue *f, CGFloat constraint, CGFloat virtualConstraint)
{
    CGFloat y = [f CGFloatValueWithConstraint:constraint virtualConstraint:virtualConstraint];
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

inline SESize SESizeMake(id w , id h, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *_w = SEUnitValueMake(w);
    SEUnitValue *_h = SEUnitValueMake(h);
    return CGSizeMake([_w CGFloatValueWithConstraint:constraintSize.width virtualConstraint:virtualConstraintSize.width],
                      [_h CGFloatValueWithConstraint:constraintSize.height virtualConstraint:virtualConstraintSize.height]);
}

inline SEPoint SEPointMake(id x, id y, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *_x = SEUnitValueMake(x);
    SEUnitValue *_y = SEUnitValueMake(y);
    return CGPointMake(SEMakeX(_x,constraintSize.width,virtualConstraintSize.width),
                       SEMakeY(_y,constraintSize.height,virtualConstraintSize.height));
}

inline SERect SERectMake(id x, id y, id w, id h, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *_x = SEUnitValueMake(x);
    SEUnitValue *_y = SEUnitValueMake(y);
    SEUnitValue *_w = SEUnitValueMake(w);
    SEUnitValue *_h = SEUnitValueMake(h);
    return CGRectMake(SEMakeX(_x,constraintSize.width,virtualConstraintSize.width),
                      SEMakeY(_y,constraintSize.height,virtualConstraintSize.height),
                      [_w CGFloatValueWithConstraint:constraintSize.width virtualConstraint:virtualConstraintSize.width],
                      [_h CGFloatValueWithConstraint:constraintSize.height virtualConstraint:virtualConstraintSize.height]);
}

inline SEVector SEVectorMake(id dx, id dy, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *_x = SEUnitValueMake(dx);
    SEUnitValue *_y = SEUnitValueMake(dy);
#if TARGET_OS_IPHONE
    _y = [SEUnitValue unitNumberWithCGFloat:-_y.numberValue.CGFloatValue unitType:_y.unitType];
#endif
    SEVector v;
    v.dx = [_x CGFloatValueWithConstraint:constraintSize.width virtualConstraint:virtualConstraintSize.width];
    v.dy = [_y CGFloatValueWithConstraint:constraintSize.height virtualConstraint:virtualConstraintSize.height];
    return v;
}

inline SESize SESizeFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    return SESizeMake(x, y, constraintSize, virtualConstraintSize);
}

inline SESize SESizeFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *w = SEUnitValueMake(dictionary[@"width"]);
    SEUnitValue *h = SEUnitValueMake(dictionary[@"height"]);
    return SESizeMake(w, h, constraintSize, virtualConstraintSize);
}

inline SESize SESizeFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SESizeFromArray(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SESizeFromDictionary(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_sizeValue];
    }
    return CGSizeZero;
}

inline SEPoint SEPointFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    return SEPointMake(x, y, constraintSize, virtualConstraintSize);
}

inline SEPoint SEPointFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *x = SEUnitValueMake(dictionary[@"x"]);
    SEUnitValue *y = SEUnitValueMake(dictionary[@"y"]);
    return SEPointMake(x, y, constraintSize, virtualConstraintSize);
}

inline SEPoint SEPointFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SEPointFromArray(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SEPointFromDictionary(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_pointValue];
    }
    return CGPointZero;
}

inline SEVector SEVectorFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    return SEVectorMake(x, y, constraintSize, virtualConstraintSize);
}

inline SEVector SEVectorFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *dx = SEUnitValueMake(dictionary[@"dx"]);
    SEUnitValue *dy = SEUnitValueMake(dictionary[@"dy"]);
    return SEVectorMake(dx, dy, constraintSize, virtualConstraintSize);
}

inline SEVector SEVectorFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SEVectorFromArray(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SEVectorFromDictionary(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_vectorValue];
    }
    SEVector v;
    v.dx = 0;
    v.dy = 0;
    return v;
}

inline SERect SERectFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *x = SEUnitValueMake(array[0]);
    SEUnitValue *y = SEUnitValueMake(array[1]);
    SEUnitValue *w = SEUnitValueMake(array[2]);
    SEUnitValue *h = SEUnitValueMake(array[3]);
    return SERectMake(x, y, w, h, constraintSize, virtualConstraintSize);
}

inline SERect SERectFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize)
{
    SEUnitValue *x = SEUnitValueMake(dictionary[@"x"]);
    SEUnitValue *y = SEUnitValueMake(dictionary[@"y"]);
    SEUnitValue *w = SEUnitValueMake(dictionary[@"width"]);
    SEUnitValue *h = SEUnitValueMake(dictionary[@"height"]);
    return SERectMake(x, y, w, h, constraintSize, virtualConstraintSize);
}

inline SERect SERectFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return SERectFromArray(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SERectFromDictionary(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_rectValue];
    }
    return CGRectZero;
}


inline SEEdgeInsets SEEdgeInsetsFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize)
{
    CGFloat top = [[SEUnitValueMake(array[0]) numberValue] CGFloatValue];
    CGFloat left = [[SEUnitValueMake(array[1]) numberValue] CGFloatValue];
    CGFloat bottom = [[SEUnitValueMake(array[2]) numberValue] CGFloatValue];
    CGFloat right = [[SEUnitValueMake(array[3]) numberValue] CGFloatValue];
    return SEEdgeInsetsMake(top, left, bottom, right);
}

inline SEEdgeInsets SEEdgeInsetsFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize)
{
    CGFloat top = [[SEUnitValueMake(dictionary[@"top"]) numberValue] CGFloatValue];
    CGFloat left = [[SEUnitValueMake(dictionary[@"left"]) numberValue] CGFloatValue];
    CGFloat bottom = [[SEUnitValueMake(dictionary[@"bottom"]) numberValue] CGFloatValue];
    CGFloat right = [[SEUnitValueMake(dictionary[@"right"]) numberValue] CGFloatValue];
    return SEEdgeInsetsMake(top, left, bottom, right);
}

inline SEEdgeInsets SEEdgeInsetsFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize)
{
    if ([obj isKindOfClass:[NSArray class]]) {
        return SEEdgeInsetsFromArray(obj, constraintSize, virtualConstraintSize);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return SEEdgeInsetsFromDictionary(obj, constraintSize, virtualConstraintSize);
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
