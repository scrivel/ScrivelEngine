//
//  SECALayer.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/03/12.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SECALayer.h"

@import ObjectiveC;
@implementation SECALayer

+ (instancetype)layerWithContentLayer:(CALayer *)contentLayer
{
    return [[self alloc] init];
}

- (instancetype)initWithContentLayer:(CALayer *)contentLayer
{
    [self setContentLayer:contentLayer];
    return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return (BOOL)[_contentLayer respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_contentLayer methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:_foregroundLayer];
    [invocation invokeWithTarget:_backgroundLayer];
    [invocation invokeWithTarget:_contentLayer];
}

- (void)setContentLayer:(CALayer *)contentLayer
{
    _contentLayer = contentLayer;
    _foregroundLayer = [contentLayer presentationLayer];
    _backgroundLayer = [contentLayer presentationLayer];
}

@end
