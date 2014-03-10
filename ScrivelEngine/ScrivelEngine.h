//
//  ScrivelEngine.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const SEWaitBeganEvent;
extern NSString *const SEWaitCompletionEvent;
extern NSString *const SEAnimationCompletionEvent;
extern NSString *const SETextDisplayCompletionEvent;

@class SEScript, SEMethod, SEBasicApp;
@protocol SEClassProxy, SEApp, SELayerClass, SETextLayerClass, SETextLayerDelegate, SECharacterLayerClass;

#if TARGET_OS_IPHONE
#define SEView UIView
#define SEImage UIImage
#define SEFont UIFont
#define SEColor UIColor
#define SEEdgeInsetsMake(t,l,b,r) UIEdgeInsetsMake(t,l,b,r)
#define NSStringFromSEPoint(p) NSStringFromCGPoint(p)
typedef UIEdgeInsets SEEdgeInsets;
typedef CGPoint SEPoint;
typedef CGRect SERect;
typedef CGSize SESize;
#elif TARGET_OS_MAC
#define SEView NSView
#define SEImage NSImage
#define SEFont NSFont
#define SEColor NSColor
#define SEEdgeInsetsMake(t,l,b,r) NSEdgeInsetsMake(t,l,b,r)
#define NSStringFromSEPoint(p) NSStringFromPoint(p)
typedef NSEdgeInsets SEEdgeInsets;
typedef NSPoint SEPoint;
typedef NSRect SERect;
typedef NSSize SESize;
#endif

#define SENilInteger NSIntegerMin
#define SENilUInteger NSUIntegerMax
#define SENilCGFloat CGFLOAT_MIN
#define SENilDouble DBL_MIN

#define VALID_CGFLOAT(d) ((CGFloat)d != SENilCGFloat)
#define ROUND_CGFLOAT(d) (VALID_CGFLOAT(d) ? d : (CGFloat)0.0)
#define VALID_DOUBLE(d) ((double)d != SENilDouble)
#define ROUND_DOUBLE(d) (VALID_DOUBLE(d) ? d : (double)0.0)
#define VALID_INT(i) (i != SENilInteger)
#define VALID_UINT(i) (I != SENilUInteger)

typedef NS_ENUM(NSUInteger, SEPositionType){
    SEPositionTypePX = 1,
    SEPositionTypeNormalized
};

typedef NS_ENUM(NSUInteger, SESizeType){
    SESizeTypePX = 1,
    SESizeTypeNormalized
};

typedef NS_ENUM(NSUInteger, SETextAlignment) {
    SETextAlignmentDefault = 0,
    SETextAlignmentLeft,
    SETextAlignmentCenter,
    SETextAlignmentRight
};

#define ScrivelEngineSppedNoWait 0

@interface ScrivelEngine : NSObject

+ (instancetype)engineWithRootView:(SEView*)rootView;

// レイヤーを管理するrootのview
@property (nonatomic, weak) SEView *rootView;
@property (nonatomic) id<SEClassProxy> classProxy;
@property (nonatomic, readonly) BOOL isWaiting;
@property (nonatomic) CGFloat speed;
// アプリケーション本体
@property (nonatomic, readonly) id<SEApp> app;
@property (nonatomic, readonly) id<SELayerClass> layer;
@property (nonatomic, readonly) id<SETextLayerClass> text;
@property (nonatomic, readonly) id<SECharacterLayerClass> chara;

// SEScriptを実行
- (id)evaluateScript:(NSString*)script error:(NSError**)error;
// スクリプトをキューイング
- (id)enqueueScript:(SEScript*)script prior:(BOOL)prior;
// スクリプトをlint
- (BOOL)validateScript:(NSString*)script error:(NSError**)error;
// 秒数をエンジンの実行時間にコンバートする
- (CFTimeInterval)convertDuration:(CFTimeInterval)duration;

@end