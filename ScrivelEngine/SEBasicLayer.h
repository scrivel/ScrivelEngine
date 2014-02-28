
//
//  SEbasicLayer.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEBasicObject.h"
#import "SELayer.h"
#import "SEBasicApp.h"
#import <objc/runtime.h>


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

// CAAnimationを同期的に実行するためのinline関数
static inline void se_animate_synch(void(^block)(),void(^completion)()){
    [CATransaction begin];
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    CFDateRef distantFuture = (__bridge CFDateRef)[NSDate distantFuture];
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(NULL, CFDateGetAbsoluteTime(distantFuture), 0, 0, 0, NULL, NULL);
    CFRunLoopAddTimer(rl, timer, kCFRunLoopDefaultMode);
    [CATransaction setCompletionBlock:^{
        CFRunLoopStop(rl);
        if (completion) completion();
    }];
    if (block) block();
    [CATransaction commit];
    CFRunLoopRun();
    CFRunLoopTimerInvalidate(timer);
    CFRelease(timer);
}

@interface SEBasicLayerClass : SEBasicObjectClass <SELayerClass>

@property (nonatomic, readonly) NSDictionary *layers;

@end

@interface SEBasicLayer : SEBasicObject <SELayerInstance>

@property (nonatomic) unsigned int index;
@property (nonatomic) CALayer *layer;

- (void)enqueuAnimationForKeyPath:(NSString*)keyPath
                          toValue:(id)value
                         duration:(NSTimeInterval)duration
                       completion:(void(^)())completion;
- (void)addAnimation:(CAAnimation*)animation
              forKey:(NSString *)key
          completion:(void(^)())completion;

@end

