
//
//  SEbasicLayer.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEBasicObject.h"
#import "SELayer.h"
#import "SEBasicApp.h"
#import "NSNumber+CGFloat.h"
#import "NSValue+ScrivelEngine.h"
#import <objc/runtime.h>

#define KEY_IS(k) [key isEqualToString:k]

#define VH self.holder.engine.rootView.bounds.size.height
#define VW self.holder.engine.rootView.bounds.size.width

#define NORM_POSITION ([(SEBasicApp*)self.holder.engine.app positionType] == SEPositionTypeNormalized)
#define NORM_SIZE ([(SEBasicApp*)self.holder.engine.app sizeType] == SESizeTypeNormalized)

#define X(x) (NORM_POSITION ? (CGFloat)(x*VW) : x)

// iOSの左上座標をMacの左下座標に変換する
#if TARGET_OS_IPHONE
#define Y(y) (NORM_POSITION ? (VH - (CGFloat)(y*VH)) : VH - y)
#else
#define Y(y) (NORM_POSITION ? (CGFloat)(y*VH) : y)
#endif

#define W(w) (NORM_SIZE ? (CGFloat)(w*VW) : w)
#define H(h) (NORM_SIZE ? (CGFloat)(h*VH) : h)

#if TARGET_OS_IPHONE
#define RADIAN(deg) -(deg*(M_PI/180.0f))
#elif TARGET_OS_MAC
#define RADIAN(deg) (deg*(M_PI/180.0f))
#endif

// PositionType, OSの違いを吸収してCALayer上の正しい値を取得する
#define SESizeMake(w,h) CGSizeMake(W(w),H(h))
#define SEPointMake(x,y) CGPointMake(X(x),Y(y))
#define SERectMake(x,y,w,h) CGRectMake(X(x), Y(y), W(w), H(h))

static inline CGFloat ZERO_TO_ONE(CGFloat f)
{
    CGFloat _f = ROUND_CGFLOAT(f);
    if (_f < 0) {
        return 0.0;
    }else if (_f > 1){
        return 1.0;
    }
    return _f;
}

#define CGSizeFromArray(a) CGSizeMake([a[0] CGFloatValue], [a[1] CGFloatValue])
#define CGSizeFromDictionary(d) CGSizeMake([d[@"width"] CGFloatValue], [d[@"height"] CGFloatValue])

static inline CGSize CGSizeFromObject(id obj)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return CGSizeFromArray(obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return CGSizeFromDictionary(obj);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_sizeValue];
    }
    return CGSizeZero;
}

#define CGPointFromArray(a) CGPointMake([a[0] CGFloatValue], [a[1] CGFloatValue])
#define CGPointFromDictionary(d) CGPointMake([d[@"x"] CGFloatValue], [d[@"y"] CGFloatValue])

static inline CGPoint CGPointFromObject(id obj)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return CGPointFromArray(obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return CGPointFromDictionary(obj);
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_pointValue];
    }
    return CGPointZero;
}

#define CGRectFromArray(a) CGRectMake([a[0] CGFloatValue], [a[1] CGFloatValue], [a[2] CGFloatValue], [a[3] CGFloatValue])
#define CGRectFromDictionary(d) CGRectMake([d[@"x"] CGFloatValue], [d[@"y"] CGFloatValue], [d[@"width"] CGFloatValue], [d[@"height"] CGFloatValue])

static inline CGRect CGRectFromObject(id obj)
{
    if ([obj isKindOfClass:[NSArray class]]){
        return CGRectFromArray(obj);
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return CGRectFromDictionary(obj);        
    }else if ([obj isKindOfClass:[NSValue class]]){
        return [obj se_rectValue];
    }
    return CGRectZero;
}

@interface SEBasicLayerClass : SEBasicObjectClass <SELayerClass>

@property (nonatomic, readonly) NSDictionary *layers;
@property (nonatomic) NSUInteger activeAnimationCount;
@property (nonatomic) NSDictionary *definedAnimations;

@end

@interface SEBasicLayer : SEBasicObject <SELayerInstance>

@property (nonatomic) id<NSCopying> key;
@property (nonatomic) unsigned int index;
@property (nonatomic) CALayer *layer;
@property (nonatomic, readonly) BOOL isChaining;
@property (nonatomic, readonly) BOOL isRepeatingForever;

@end

