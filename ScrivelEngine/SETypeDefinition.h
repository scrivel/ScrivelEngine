//
//  SETypeDefinition.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#ifndef ScrivelEngine_SETypeDefinition_h
#define ScrivelEngine_SETypeDefinition_h

struct SEVector {
    CGFloat dx;
    CGFloat dy;
};
typedef struct SEVector SEVector;
#define SE_TARGET_OS_IPHONE TARGET_OS_IPHONE
#define SE_TARGET_OS_MAC (TARGET_OS_MAC && !TARGET_OS_IPHONE)
#if SE_TARGET_OS_IPHONE
#define SEWindow UIWindow
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
#elif SE_TARGET_OS_MAC
#define SEWindow NSWindow
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

typedef NS_ENUM(NSUInteger, SETextAlignment) {
    SETextAlignmentDefault = 0,
    SETextAlignmentLeft,
    SETextAlignmentCenter,
    SETextAlignmentRight
};

#define ScrivelEngineSppedNoWait 0

#endif
