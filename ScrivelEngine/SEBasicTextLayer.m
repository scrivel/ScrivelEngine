
//
//  _SEConcretTextFrame.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicTextLayer.h"
#import "SEApp.h"
#import "MethodSwizzling.h"

@implementation SEBasicTextLayerClass

- (instancetype)initWithEngine:(ScrivelEngine *)engine
{
    self = [super initWithEngine:engine];
    self.instanceClass = [SEBasicTextLayer class];
    return self ?: nil;
}

- (id<SEObjectInstance>)new_args:(id)args
{
    SEBasicTextLayer *new = (SEBasicTextLayer*)[super new_args:args];
    return new;
}

@end

@implementation SEBasicTextLayer
{
    NSTimer *_timer;
    NSUInteger _currentCharacterIndex;
#if TARGET_OS_IPHONE
    UITapGestureRecognizer *_tapGestureRecognizer;
#elif TARGET_OS_MAC
    SEResponderProxy *_responderProxy;
#endif
}

#pragma mark - Private

- (void)addCharacter
{
    _currentCharacterIndex++;
    if (_currentCharacterIndex > [self.text length]) {
        [self finishAnimation];
        return;
    }
    NSRange r = NSMakeRange(0, _currentCharacterIndex);
    id text;
    if ([self.text isKindOfClass:[NSString class]]) {
        text = [(NSString*)self.text substringWithRange:r];
    }else if([self.text isKindOfClass:[NSAttributedString class]]){
        text = [(NSAttributedString*)self.text attributedSubstringFromRange:r];
    }
    self.textLayer.contents = text;
}

- (void)finishAnimation
{
    [_timer invalidate];
    _isAnimating = NO;
    _currentCharacterIndex = 0;
}

- (void)setText:(id)text
{
    _text = text;
}

#pragma mark -

- (instancetype)initWithOpts:(NSDictionary *)options holder:(SEBasicObjectClass *)holder
{
    self = [super initWithOpts:options holder:holder];
    CATextLayer *tl = [CATextLayer layer];
    self.layer = tl;
    self.textLayer = tl;
    _animationInterval = 0.1f;
    _font = [SEFont systemFontOfSize:14.0];
    _padding = SEEdgeInsetsMake(0, 0, 0, 0);
#if TARGET_OS_IPHONE
    _horizontalAlignment = NSTextAlignmentLeft;
#elif TARGET_OS_MAC
    _horizontalAlignment = NSLeftTextAlignment;
#endif
#if TARGET_OS_IPHONE
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.holder.engine.rootView addGestureRecognizer:_tapGestureRecognizer];
#elif TARGET_OS_MAC
    // mousedownイベントをハンドリングするためにrootviewのレスポンダチェーンをproxyする
    _responderProxy = [[SEResponderProxy alloc] initWithDelegate:self selector:@selector(handleNSEvent:)];
    NSResponder *r = self.holder.engine.rootView.nextResponder;
    [self.holder.engine.rootView setNextResponder:_responderProxy];
    [_responderProxy setNextResponder:r];
#endif
    return self ?: nil;
}

#if TARGET_OS_IPHONE

- (void)handlePan:(UIPanGestureRecognizer*)sender
{
    NSLog(@"%@",sender);
}

#elif TARGET_OS_MAC
- (void)handleNSEvent:(NSEvent*)event
{
    NSLog(@"%@",event);
}

#endif

#pragma mark - CALayerDelegate

- (void)setInterval_interval:(NSTimeInterval)interval
{
    if VALID_DOUBLE(interval) _animationInterval = interval;
}

- (void)text_text:(NSString *)text noanimate:(BOOL)noanimate
{
	// text
    if ([text isKindOfClass:[NSAttributedString class]]) {
        // 装飾文字の場合もある
    }else if ([text isKindOfClass:[NSString class]]){
        
    }
}

- (void)start
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval
                                              target:self
                                            selector:@selector(addCharacter)
                                            userInfo:nil
                                             repeats:YES];
    [_timer fire];}

- (void)pause
{
    [_timer invalidate];
}

- (void)resume
{
    [_timer fire];
}

- (void)clear
{
	_text = nil;
    [self text_text:nil noanimate:NO];
    [self finishAnimation];
}

- (void)skip
{
	[self finishAnimation];
//    [self setfu]
}

- (void)setPadding_top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    CGFloat _top = H(ROUND_CGFLOAT(top));
    CGFloat _left = W(ROUND_CGFLOAT(left));
    CGFloat _bottom = H(ROUND_CGFLOAT(bottom));
    CGFloat _right = W(ROUND_CGFLOAT(right));
    _padding = SEEdgeInsetsMake(_top, _left, _bottom, _right);
}

- (void)setFont_name:(NSString *)name size:(CGFloat)size
{
    CGFloat _size = VALID_CGFLOAT(size) ? size : self.font.pointSize;
    SEFont *f = [SEFont fontWithName:name size:_size];
    if (f) self.textLayer.font = (__bridge CFTypeRef)(f);
}

- (void)setLineSpacing_spacing:(CGFloat)spacing
{
    if VALID_CGFLOAT(spacing) {
        NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
        ps.lineSpacing = spacing;
        SEFont *f = [SEFont systemFontOfSize:self.font.pointSize];
        NSDictionary *attr = @{NSParagraphStyleAttributeName: ps,
                               NSFontAttributeName : f};
    }
}

- (void)setHorizontalAlign_direction:(NSTextAlignment)direction
{
    
}

#pragma mark - SELayer


/*
 NSString *const NSFontAttributeName;
 NSString *const NSParagraphStyleAttributeName;
 NSString *const NSForegroundColorAttributeName;
 NSString *const NSBackgroundColorAttributeName;
 NSString *const NSLigatureAttributeName;
 NSString *const NSKernAttributeName;
 NSString *const NSStrikethroughStyleAttributeName;
 NSString *const NSUnderlineStyleAttributeName;
 NSString *const NSStrokeColorAttributeName;
 NSString *const NSStrokeWidthAttributeName;
 NSString *const NSShadowAttributeName;
 NSString *const NSTextEffectAttributeName;
 NSString *const NSAttachmentAttributeName;
 NSString *const NSLinkAttributeName;
 NSString *const NSBaselineOffsetAttributeName;
 NSString *const NSUnderlineColorAttributeName;
 NSString *const NSStrikethroughColorAttributeName;
 NSString *const NSObliquenessAttributeName;
 NSString *const NSExpansionAttributeName;
 NSString *const NSWritingDirectionAttributeName;
 NSString *const NSVerticalGlyphFormAttributeName;
 */


@end


