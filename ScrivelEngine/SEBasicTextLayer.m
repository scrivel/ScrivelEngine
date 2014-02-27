
//
//  _SEConcretTextFrame.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicTextLayer.h"
#import "SEApp.h"
#import "SEClassProxy.h"
#import "SEMethod.h"
#import "SEColorUtil.h"

@implementation SEBasicTextLayerClass
{
#if TARGET_OS_IPHONE
    UITapGestureRecognizer *_tapGestureRecognizer;
#elif TARGET_OS_MAC
    SEResponderProxy *_responderProxy;
#endif
}

- (instancetype)initWithEngine:(ScrivelEngine *)engine classIdentifier:(NSString *)classIdentifier
{
    self = [super initWithEngine:engine classIdentifier:classIdentifier];
    self.instanceClass = [SEBasicTextLayer class];
    // プライマリテキストレイヤだけはタップイベントをキャプチャ出来るようにする
    // LayerInstanceがResponderProxyをもつとなぜかクラッシュすることがあるので
    // プライマリレイヤのindexによってdelegate先を変えるようにする
#if !TARGET_OS_IPHONE
    // mousedownイベントをハンドリングするためにrootviewのレスポンダチェーンをproxyする
    _responderProxy = [[SEResponderProxy alloc] initWithDelegate:nil selector:@selector(handleNSEvent:)];
    NSResponder *r = self.engine.rootView.nextResponder;
    [self.engine.rootView setNextResponder:_responderProxy];
    [_responderProxy setNextResponder:r];
#endif
    return self ?: nil;
}

- (id<SEObjectInstance>)new_args:(id)args
{
    SEBasicTextLayer *new = (SEBasicTextLayer*)[super new_args:args];
    // まだレイヤーがない場合はそのレイヤーをprimaryに設定する
    if (self.layers.count == 1) {
        [self setPrimary_index:new.index];
    }
    return new;
}

- (id)callStatic_method:(SEMethod *)method
{
    SEL s =[self.engine.classProxy selectorForMethodIdentifier:method.name classIdentifier:self.classIdentifier];
    // セレクタがマッピングされているが、クラスメソッドでないものはPrimaryにProxyする
    if (s && ![self respondsToSelector:s]) {
        return [self.primaryTextLayer callInstance_method:method];
    }
    return [super callStatic_method:method];
}

- (void)setPrimary_index:(NSUInteger)index
{
    SEBasicTextLayer *l = [self at_index:index];
    if (l) {
#if TARGET_OS_IPHONE
        [self.engine.rootView removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:l action:@selector(handleTap:)];
        [self.engine.rootView addGestureRecognizer:_tapGestureRecognizer];
#elif TARGET_OS_MAC
        _responderProxy.delegate = l;
#endif
        _primaryTextLayer = l;
    }
}

- (void)setNameLayer_index:(NSUInteger)index
{
    SEBasicTextLayer *l = [self at_index:index];
    if (l) {
        _primaryNameLayer = l;
    }
}

- (void)setName_name:(NSString *)name
{
    [self.primaryNameLayer setText_text:name noanimate:YES];
}

@end

@implementation SEBasicTextLayer
{
    NSTimer *_timer;
    NSUInteger _currentCharacterIndex;
}

#pragma mark -

- (instancetype)initWithOpts:(NSDictionary *)options holder:(SEBasicObjectClass *)holder
{
    self = [super initWithOpts:options holder:holder];
    CATextLayer *tl = [CATextLayer layer];
    self.layer = tl;
    self.textLayer = tl;
    self.textLayer.wrapped = YES;
    self.textLayer.fontSize = 14.0f;
    self.textLayer.foregroundColor = [[SEColor blackColor] CGColor];
    
    _animationInterval = 0.1f;
    _font = [SEFont systemFontOfSize:14.0f];
    _padding = SEEdgeInsetsMake(0, 0, 0, 0);
#if TARGET_OS_IPHONE
    _horizontalAlignment = NSTextAlignmentLeft;
#elif TARGET_OS_MAC
    _horizontalAlignment = NSLeftTextAlignment;
#endif
    return self ?: nil;
}

#if TARGET_OS_IPHONE
- (void)handleTap:(UIPanGestureRecognizer*)sender
{
    [self handleClickOrTapInPoint:[sender locationInView:self.holder.engine.rootView]];
}

#elif TARGET_OS_MAC
- (void)handleNSEvent:(NSEvent*)event
{
    [self handleClickOrTapInPoint:[event locationInWindow]];
}
#endif

- (void)handleClickOrTapInPoint:(SEPoint)point
{
    CGRect r = self.layer.bounds;
    r = [self.layer convertRect:r toLayer:self.holder.engine.rootView.layer];
    if (CGRectContainsPoint(r, point)) {
        if (self.isAnimating) {
            [self skip];
        }else{
            [self.holder.engine.textLayerDelegate textLayerDidRecognizeTapTwice:self];
        }
    }
}

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
    self.textLayer.string = text;
}

- (void)finishAnimation
{
    [_timer invalidate];
    _isAnimating = NO;
    _currentCharacterIndex = 0;
    [self.holder.engine.textLayerDelegate textLayer:self didFinishDisplayText:self.text];
}

#pragma mark - CALayer

- (void)setInterval_interval:(NSTimeInterval)interval
{
    if VALID_DOUBLE(interval) _animationInterval = interval;
}

- (void)setColor_color:(NSString *)color
{
    SEColor *c = [SEColorUtil colorWithHEXString:color];
    if (c) self.textLayer.foregroundColor = [c CGColor];
}

- (void)setText_text:(NSString *)text noanimate:(BOOL)noanimate
{
    NSString *__text = [text copy];
	// text
    if ([text isKindOfClass:[NSAttributedString class]]) {
        // 装飾文字の場合もある
    }else if ([text isKindOfClass:[NSString class]]){
        
    }
    // パースしたものをセット
    _text = __text;
    if (!noanimate) {
        [self start];
    }else{
        self.textLayer.string = __text;
    }
}

- (void)start
{
    _isAnimating = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval target:self selector:@selector(addCharacter) userInfo:nil repeats:YES];
    [_timer fire];
}

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
    [self setText_text:nil noanimate:NO];
    [self finishAnimation];
}

- (void)skip
{
    self.textLayer.string = self.text;
	[self finishAnimation];
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
        NSAttributedString *as;
        if ([self.text isKindOfClass:[NSString class]]) {
            as= [[NSAttributedString alloc] initWithString:self.text attributes:attr];
        }else if ([self.text isKindOfClass:[NSAttributedString class]]){
        }
    }
}

- (void)setHorizontalAlign_direction:(NSTextAlignment)direction
{
    
}

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


