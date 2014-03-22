//
//  SEGeometory.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEUnitFloat.h"
#import "NSNumber+CGFloat.h"
#import "NSValue+ScrivelEngine.h"

#ifndef ScrivelEngine_SEGeometory_h
#define ScrivelEngine_SEGeometory_h

#define VALID_CGFLOAT(d) ((CGFloat)d != SENilCGFloat)
#define ROUND_CGFLOAT(d) (VALID_CGFLOAT(d) ? d : (CGFloat)0.0)
#define VALID_DOUBLE(d) ((double)d != SENilDouble)
#define ROUND_DOUBLE(d) (VALID_DOUBLE(d) ? d : (double)0.0)
#define VALID_INT(i) (i != SENilInteger)
#define VALID_UINT(i) (I != SENilUInteger)

static inline SEUnitFloat * SEUnitFloatMake(id obj)
{
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [SEUnitFloat unitNumberWithCGFloat:[obj CGFloatValue] unitType:SEUnitTypeDefault];
    }else if ([obj isKindOfClass:[NSString class]]){
        return [SEUnitFloat unitNumberWithValueDescription:obj];
    }else if ([obj isKindOfClass:[SEUnitFloat class]]){
        return obj;
    }
    return nil;
}

static inline CGFloat SEMakeX(CGFloat constraint, SEUnitFloat *f)
{
    return [f CGFloatValueWithConstraint:constraint];
}

static inline CGFloat SEMakeY(CGFloat constraint, SEUnitFloat *f)
{
    CGFloat y = [f CGFloatValueWithConstraint:constraint];
#if TARGET_OS_IPHONE
    return constraint - y;
#else
    return y;
#endif
}

static inline CGPoint CGPointFromObject(id obj)
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

static inline SESize SESizeMake(SESize constraintSize, id w , id h)
{
    SEUnitFloat *_w = SEUnitFloatMake(w);
    SEUnitFloat *_h = SEUnitFloatMake(h);
    return CGSizeMake([_w CGFloatValueWithConstraint:constraintSize.width],
                      [_h CGFloatValueWithConstraint:constraintSize.height]);
}

static inline SEPoint SEPointMake(SESize constraintSize, id x, id y)
{
    SEUnitFloat *_x = SEUnitFloatMake(x);
    SEUnitFloat *_y = SEUnitFloatMake(y);
    return CGPointMake(SEMakeX(constraintSize.width, _x), SEMakeY(constraintSize.height, _y));
}

static inline SERect SERectMake(SESize constraintSize, id x, id y, id w, id h)
{
    SEUnitFloat *_x = SEUnitFloatMake(x);
    SEUnitFloat *_y = SEUnitFloatMake(y);
    SEUnitFloat *_w = SEUnitFloatMake(w);
    SEUnitFloat *_h = SEUnitFloatMake(h);
    return CGRectMake(SEMakeX(constraintSize.width, _x),
                      SEMakeY(constraintSize.height, _y),
                      [_w CGFloatValueWithConstraint:constraintSize.width],
                      [_h CGFloatValueWithConstraint:constraintSize.height]);
}

static inline SEVector SEVectorMake(SESize constraintSize, id dx, id dy)
{
    SEUnitFloat *_x = SEUnitFloatMake(dx);
    SEUnitFloat *_y = SEUnitFloatMake(dy);
#if TARGET_OS_IPHONE
    _y = [SEUnitFloat unitNumberWithCGFloat:-_y.numberValue.CGFloatValue unitType:_y.unitType];
#endif
    SEVector v;
    v.dx = [_x CGFloatValueWithConstraint:constraintSize.width];
    v.dy = [_y CGFloatValueWithConstraint:constraintSize.height];
    return v;
}

static inline SESize SESizeFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitFloat *x = SEUnitFloatMake(array[0]);
    SEUnitFloat *y = SEUnitFloatMake(array[1]);
    return SESizeMake(constraintSize, x, y);
}

static inline SESize SESizeFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitFloat *w = SEUnitFloatMake(dictionary[@"width"]);
    SEUnitFloat *h = SEUnitFloatMake(dictionary[@"height"]);
    return SESizeMake(constraintSize, w, h);
}

static inline SESize SESizeFromObject(SESize constraintSize, id obj)
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

static inline SEPoint SEPointFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitFloat *x = SEUnitFloatMake(array[0]);
    SEUnitFloat *y = SEUnitFloatMake(array[1]);
    return SEPointMake(constraintSize, x, y);
}

static inline SEPoint SEPointFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitFloat *x = SEUnitFloatMake(dictionary[@"x"]);
    SEUnitFloat *y = SEUnitFloatMake(dictionary[@"y"]);
    return SEPointMake(constraintSize, x, y);
}

static inline SEPoint SEPointFromObject(SESize constraintSize, id obj)
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

static inline SEVector SEVectorFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitFloat *x = SEUnitFloatMake(array[0]);
    SEUnitFloat *y = SEUnitFloatMake(array[1]);
    return SEVectorMake(constraintSize, x, y);
}

static inline SEVector SEVectorFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitFloat *dx = SEUnitFloatMake(dictionary[@"dx"]);
    SEUnitFloat *dy = SEUnitFloatMake(dictionary[@"dy"]);
    return SEVectorMake(constraintSize, dx, dy);
}

static inline SEVector SEVectorFromObject(SESize constraintSize, id obj)
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

static inline SERect SERectFromArray(SESize constraintSize, NSArray *array)
{
    SEUnitFloat *x = SEUnitFloatMake(array[0]);
    SEUnitFloat *y = SEUnitFloatMake(array[1]);
    SEUnitFloat *w = SEUnitFloatMake(array[2]);
    SEUnitFloat *h = SEUnitFloatMake(array[3]);
    return SERectMake(constraintSize, x, y, w, h);
}

static inline SERect SERectFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    SEUnitFloat *x = SEUnitFloatMake(dictionary[@"x"]);
    SEUnitFloat *y = SEUnitFloatMake(dictionary[@"y"]);
    SEUnitFloat *w = SEUnitFloatMake(dictionary[@"width"]);
    SEUnitFloat *h = SEUnitFloatMake(dictionary[@"height"]);
    return SERectMake(constraintSize, x, y, w, h);
}

static inline SERect SERectFromObject(SESize constraintSize, id obj)
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


static inline SEEdgeInsets SEEdgeInsetsFromArray(SESize constraintSize, NSArray *array)
{
    CGFloat top = [[SEUnitFloatMake(array[0]) numberValue] CGFloatValue];
    CGFloat left = [[SEUnitFloatMake(array[1]) numberValue] CGFloatValue];
    CGFloat bottom = [[SEUnitFloatMake(array[2]) numberValue] CGFloatValue];
    CGFloat right = [[SEUnitFloatMake(array[3]) numberValue] CGFloatValue];
    return SEEdgeInsetsMake(top, left, bottom, right);
}

static inline SEEdgeInsets SEEdgeInsetsFromDictionary(SESize constraintSize, NSDictionary *dictionary)
{
    CGFloat top = [[SEUnitFloatMake(dictionary[@"top"]) numberValue] CGFloatValue];
    CGFloat left = [[SEUnitFloatMake(dictionary[@"left"]) numberValue] CGFloatValue];
    CGFloat bottom = [[SEUnitFloatMake(dictionary[@"bottom"]) numberValue] CGFloatValue];
    CGFloat right = [[SEUnitFloatMake(dictionary[@"right"]) numberValue] CGFloatValue];
    return SEEdgeInsetsMake(top, left, bottom, right);
}

static inline SEEdgeInsets SEEdgeInsetsFromObject(SESize constraintSize, id obj)
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

static inline CGFloat SEMakeRadian (CGFloat degree)
{
#if TARGET_OS_IPHONE
    return -(CGFloat)(degree*(M_PI/180.0f));
#else
    return (CGFloat)(degree*(M_PI/180.0f));
#endif
}
static inline CGFloat SENormalize(CGFloat f)
{
    CGFloat _f = ROUND_CGFLOAT(f);
    if (_f < 0) {
        return 0.0;
    }else if (_f > 1){
        return 1.0;
    }
    return _f;
}

#endif
