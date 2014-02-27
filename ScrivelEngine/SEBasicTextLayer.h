
//
//  _SEConcretTextFrame.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"
#import "SEBasicLayer.h"
#import "SETextLayer.h"
#import "SETextLayerDelegate.h"
#if !TARGET_OS_IPHONE
#import "SEResponderProxy.h"
#endif

@class SEBasicTextLayer;
@interface SEBasicTextLayerClass : SEBasicLayerClass <SETextLayerClass>

@property (nonatomic, readonly) SEBasicTextLayer *primaryTextLayer;
@property (nonatomic, readonly) SEBasicTextLayer *primaryNameLayer;

@end

@interface SEBasicTextLayer : SEBasicLayer <SETextLayerInstance>

@property (nonatomic) CATextLayer *textLayer;
@property (nonatomic, readonly) NSTimeInterval animationInterval;
@property (nonatomic, readonly) SEEdgeInsets padding;
@property (nonatomic, readonly) SEFont *font;
// 現在表示している文字列。NSString or NSAttributedString
@property (nonatomic, readonly) id text;
@property (nonatomic, readonly) NSTextAlignment *horizontalAlignment;
@property (nonatomic, readonly) BOOL isAnimating;

#if TARGET_OS_IPHONE
- (void)handleTap:(UIPanGestureRecognizer*)sender;
#elif TARGET_OS_MAC
- (void)handleNSEvent:(NSEvent*)event;
#endif

@end
