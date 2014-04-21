
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
#import "NSObject+KXEventEmitter.h"
#import "NSNumber+CGFloat.h"

@interface SEBasicTextLayerClass ()

@property (nonatomic, readwrite) SEBasicTextLayer *primaryTextLayer;
@property (nonatomic, readwrite) SEBasicTextLayer *primaryNameLayer;

@end
@implementation SEBasicTextLayerClass
{
#if TARGET_OS_IPHONE
    UITapGestureRecognizer *_tapGestureRecognizer;
#elif TARGET_OS_MAC
    SEResponderProxy *_responderProxy;
#endif
}

- (Class)instanceClass
{
    return [SEBasicTextLayer class];
}

- (id<SEObjectInstance>)new_args:(id)args
{
    SEBasicTextLayer *new = (SEBasicTextLayer*)[super new_args:args];
    // まだレイヤーがない場合はそのレイヤーをprimaryに設定する
    if (self.layers.count == 1) {
        [self setPrimaryTextLayer:new];
    }
    return new;
}

- (id)callMethod_method:(SEMethod *)method
{
    SEL s =[self.engine.classProxy selectorForMethodIdentifier:method.name classIdentifier:self.classIdentifier];
    // セレクタがマッピングされているが、クラスメソッドでないものはPrimaryにProxyする
    if (s && ![self respondsToSelector:s]) {
        return [self.primaryTextLayer callMethod_method:method];
    }
    return [super callMethod_method:method];
}

- (void)set_key:(NSString *)key value:(id)value
{
    if (KEY_IS(@"primary")) {
        [self setPrimaryTextLayer:[self get_key:value]];
    }else if (KEY_IS(@"nameLabel")){
        [self setPrimaryNameLayer:[self get_key:value]];
    }else{
        [super set_key:key value:value];
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
    CFTimeInterval _interval;
    NSString *_fontName;
    CGFloat _fontSize;
    SEColor *_color;
    CGFloat _lineSpacing;
    SEEdgeInsets _padding;
    SETextAlignment _textAlign;
    
}

@synthesize interval = _interval;
@synthesize fontName = _fontName;
@synthesize fontSize = _fontSize;
@synthesize color = _color;
@synthesize lineSpacing = _lineSpacing;
@synthesize padding = _padding;
@synthesize textAlign = _textAlign;

#pragma mark -

- (instancetype)init
{
    _textLayer = [CATextLayer layer];
    _textLayer.wrapped = YES;
    _textLayer.fontSize = 14.0f;
    _textLayer.foregroundColor = [[SEColor blackColor] CGColor];
#if TARGET_OS_IPHONE
    // retina上でフォントがぼやけるのを防ぐ
    _textLayer.contentsScale = [[UIScreen mainScreen] scale];
#endif
    
    _font = [SEFont systemFontOfSize:14.0f];
    _currentCharacterIndex = 0;
    
    _interval = 0.1f;
    _fontSize = 14.0f;
    _fontName = [_font fontName];
    _textAlign = SETextAlignmentDefault;
    _padding = SEEdgeInsetsMake(0, 0, 0, 0);
    _lineSpacing = 0;
    _color = [SEColor blackColor];

    self = [super init];
    self.layer = _textLayer;
    return self ?: nil;
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
    _timer = nil;
    _isAnimating = NO;
    _currentCharacterIndex = 0;
    [self kx_emit:SETextDisplayCompletionEvent userInfo:nil center:self.engine.notificationCenter];
}

#pragma mark - CALayer

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
        // テキストの表示が終わるまでブロックする
    }else{
        self.textLayer.string = __text;
    }
}

- (void)start
{
    // waitさせる
    _isAnimating = YES;
    // 表示している文字を消す
    // 最初のセットで一度消す
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    self.textLayer.string = nil;
    [CATransaction commit];
    // 加速or減速
    CFTimeInterval duration = [self.holder.engine convertDuration:self.interval];
    _timer = [NSTimer timerWithTimeInterval:duration target:self selector:@selector(addCharacter) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
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
    [self setText_text:nil noanimate:YES];
    [self finishAnimation];
}

- (void)skip
{
    self.textLayer.string = self.text;
	[self finishAnimation];
}

- (void)set_key:(NSString *)key value:(id)value
{
    if (KEY_IS(@"padding")) {
        [self setPadding:SEEdgeInsetsFromObject(value, VIEW_SIZE, VIRTUAL_SIZE)];
    }else if (KEY_IS(@"fontName")){
        [self setFontName:value];
    }else if (KEY_IS(@"fontSize")){
        [self setFontSize:[value CGFloatValue]];
    }else if (KEY_IS(@"color")){
        SEColor *c = [SEColorUtil colorWithHEXString:value];
        if (c) self.textLayer.foregroundColor = [c CGColor];
    }else if (KEY_IS(@"lineScacing")){
        [self setLineSpacing:[value CGFloatValue]];
    }else if (KEY_IS(@"textAlign")){
        NSString *key = value;
        if (KEY_IS(@"left")) {
            [self setTextAlign:SETextAlignmentLeft];
        }else if (KEY_IS(@"center")){
            [self setTextAlign:SETextAlignmentCenter];
        }else if (KEY_IS(@"right")){
            [self setTextAlign:SETextAlignmentRight];
        }
    }else if (KEY_IS(@"interval")){
        self.interval = [value doubleValue];
    }else{
        [super set_key:key value:value];
    }
}

- (void)setPadding:(SEEdgeInsets)padding
{
    _padding = padding;
}

- (void)setFontName:(NSString *)fontName
{
    CGFloat size = self.textLayer.fontSize;
    SEFont *f = [SEFont fontWithName:fontName size:size];
    self.textLayer.font = (__bridge CFTypeRef)f;
    _fontName = fontName;
}

- (void)setFontSize:(CGFloat)fontSize
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    self.textLayer.fontSize = fontSize;
    [CATransaction commit];
    _fontSize = fontSize;
}

- (void)setColor:(SEColor *)color
{
    self.textLayer.foregroundColor = (__bridge CGColorRef)(color);
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
    ps.lineSpacing = lineSpacing;
    SEFont *f = [SEFont systemFontOfSize:self.font.pointSize];
    NSDictionary *attr = @{NSParagraphStyleAttributeName: ps,
                           NSFontAttributeName : f};
    NSAttributedString *as;
    if ([self.text isKindOfClass:[NSString class]]) {
        as= [[NSAttributedString alloc] initWithString:self.text attributes:attr];
    }else if ([self.text isKindOfClass:[NSAttributedString class]]){
    }
    _lineSpacing = lineSpacing;
}

- (void)setTextAlign:(SETextAlignment)textAlign
{
    switch (textAlign) {
        case SETextAlignmentLeft:
            self.textLayer.alignmentMode = kCAAlignmentLeft;
            break;
        case SETextAlignmentCenter:
            self.textLayer.alignmentMode = kCAAlignmentCenter;
            break;
        case SETextAlignmentRight:
            self.textLayer.alignmentMode = kCAAlignmentRight;
            break;
        default:
            self.textLayer.alignmentMode = kCAAlignmentNatural;
            break;
    }
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


