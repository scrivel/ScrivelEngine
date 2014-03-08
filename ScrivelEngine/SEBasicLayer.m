
//
//  _SEConcretLayer.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicLayer.h"
#import "NSValue+ScrivelEngine.h"
#import "ScrivelEngine.h"
#import "SEMethod.h"
#import "SEApp.h"
#import "NSBundle+ScrivelEngine.h"
#import "NSNumber+CGFloat.h"
#import <objc/message.h>
#import "SEClassProxy.h"
#import "SEColorUtil.h"
#import "NSObject+KXEventEmitter.h"

#define kMaxLayer 1000
#define kGroupedAnimationKey @"GroupedAnimation"

@interface SEBasicLayerClass ()

@end

@implementation SEBasicLayerClass
{
    NSMutableDictionary *__layers;
    NSMutableDictionary *__definedAnimations;
}
@synthesize layers = __layers;
@synthesize definedAnimations = __definedAnimations;

#pragma makr - SEObjectClass

- (instancetype)initWithEngine:(ScrivelEngine *)engine classIdentifier:(NSString *)classIdentifier
{
    self = [super initWithEngine:engine classIdentifier:classIdentifier];
    __layers = [NSMutableDictionary new];
    __definedAnimations = [NSMutableDictionary new];
    self.instanceClass = [SEBasicLayer class];
    return self ?: nil;
}

- (void)setActiveAnimationCount:(NSUInteger)activeAnimationCount
{
    _activeAnimationCount = activeAnimationCount;
    // 実行中のアニメーションがすべて終了したら通知を出す
    if (activeAnimationCount == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SEAnimationCompletionEvent object:self];
    }
}

- (id<SEObjectInstance>)new_args:(id)args
{
    SEBasicLayer *layer;
    id _args = args;
    if (![_args isKindOfClass:[NSDictionary class]]) {
        _args = @{@"key": args};
    }
    layer = (SEBasicLayer*)[super new_args:_args];
    // 古いレイヤーを消す
    [self clear_key:layer.key];
    // 登録
    [__layers setObject:layer forKey:layer.key];
    // レイヤーを追加
    if ([args[@"index"] isKindOfClass:[NSNumber class]]) {
        [self.engine.rootView.layer insertSublayer:layer.layer atIndex:[args[@"index"] unsignedIntValue]];
    }else{
        [self.engine.rootView.layer addSublayer:layer.layer];
    }
    return layer;
}

#pragma mark - SELayerClass

- (id)get_key:(id<NSCopying>)key
{
    return [self.layers objectForKey:key];
}

- (void)clear_key:(id<NSCopying>)key
{
    [[[__layers objectForKey:key] layer] removeFromSuperlayer];
    [__layers removeObjectForKey:key];
}

- (void)clearAll
{
    for (SEBasicLayer *l in __layers.objectEnumerator) {
        [[l layer] removeFromSuperlayer];
    }
    [__layers removeAllObjects];
}

- (void)define_name:(id<NSCopying>)name animations:(NSDictionary *)animations options:(NSDictionary *)options
{
    [__definedAnimations setObject:@{@"animations": animations, @"options" : options} forKey:name];
}

@end

@interface SEBasicLayer()
{
    CAAnimationGroup *_animationGroup;
    NSString *_gravity;
    SEPoint _anchorPoint;
    CGFloat _borderWidth;
    SEColor *_bgColor;
    SEColor *_borderColor;
    SEColor *_shadowColor;
    CGFloat _shadowOpacity;
    CGFloat _shadowRadius;
    SESize _shadowOffset;
}
@end

@implementation SEBasicLayer

@synthesize gravity = _gravity;
@synthesize anchorPoint = _anchorPoint;
@synthesize bgColor = _bgColor;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowOffset = _shadowOffset;

#pragma mark - Private

#define KEY_IS(k) [key isEqualToString:k]

- (instancetype)initWithOpts:(NSDictionary *)options holder:(SEBasicObjectClass *)holder
{
    self = [super initWithOpts:options holder:holder];
    // 実体はレイヤー
    _layer = [CALayer layer];
    _layer.position = SEPointMake(0.5, 0.5);
    // parse options
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    [options enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (KEY_IS(@"key")){
            _key = options[@"key"];
        }
    }];
    [CATransaction commit];
    return self ?: nil;
}

#pragma mark - Property

- (void)set_key:(NSString *)key value:(id)value
{
    if (KEY_IS(@"index")){
        [self setIndex:[value unsignedIntValue]];
    }else if (KEY_IS(@"anchorPoint")) {
        [self setAnchorPoint:CGPointFromArray(value)];
    }else if (KEY_IS(@"gravity")){
        [self setGravity:value];
    }else if (KEY_IS(@"bgColor")){
        [self setBgColor:[SEColorUtil colorWithHEXString:value]];
    }else if (KEY_IS(@"borderColor")){
        [self setBorderColor:[SEColorUtil colorWithHEXString:value]];
    }else if (KEY_IS(@"borderWidth")){
        [self setBorderWidth:[value CGFloatValue]];
    }else if (KEY_IS(@"shadowColor")){
        [self setShadowColor:[SEColorUtil colorWithHEXString:value]];
    }else if (KEY_IS(@"shadowOpacity")){
        [self setShadowOpacity:[value CGFloatValue]];
    }else if (KEY_IS(@"shadowRadius")){
        [self setShadowRadius:[value CGFloatValue]];
    }else if (KEY_IS(@"shadowOffset")){
        [self setShadowOffset:CGSizeFromArray(value)];
    }else{
        [super set_key:key value:value];
    }
}

- (void)setIndex:(unsigned int)index
{
    [self.holder.engine.rootView.layer insertSublayer:self.layer atIndex:index];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
#if TARGET_OS_IPHONE
    CGFloat _y = 1 - anchorPoint.y;
#else
    CGFloat _y = anchorPoint.y;
#endif
	self.layer.anchorPoint = CGPointMake(anchorPoint.x, _y);
    _anchorPoint = anchorPoint;
}

- (void)setGravity:(NSString *)gravity
{
    if ([gravity isEqualToString:@"center"] ) {
        self.layer.contentsGravity = kCAGravityCenter;
    }
    else if ([gravity isEqualToString:@"top"] ) {
        self.layer.contentsGravity = kCAGravityTop;
    }
    else if ([gravity isEqualToString:@"bottom"] ) {
        self.layer.contentsGravity = kCAGravityBottom;
    }
    else if ([gravity isEqualToString:@"left"] ) {
        self.layer.contentsGravity = kCAGravityLeft;
    }
    else if ([gravity isEqualToString:@"right"] ) {
        self.layer.contentsGravity = kCAGravityRight;
    }
    else if ([gravity isEqualToString:@"top-left"] ) {
        self.layer.contentsGravity = kCAGravityTopLeft;
    }
    else if ([gravity isEqualToString:@"top-right"] ) {
        self.layer.contentsGravity = kCAGravityTopRight;
    }
    else if ([gravity isEqualToString:@"bottom-left"] ) {
        self.layer.contentsGravity = kCAGravityTopLeft;
    }
    else if ([gravity isEqualToString:@"bottom-right"] ) {
        self.layer.contentsGravity = kCAGravityBottomRight;
    }
    else if ([gravity isEqualToString:@"resize"] ) {
        self.layer.contentsGravity = kCAGravityResize;
    }
    else if ([gravity isEqualToString:@"resize-aspect"] ) {
        self.layer.contentsGravity = kCAGravityResizeAspect;
    }
    else if ([gravity isEqualToString:@"resize-aspect-fill"] ) {
        self.layer.contentsGravity = kCAGravityResizeAspectFill;
    }
    _gravity = gravity;
}

#pragma mark - Appearence

- (void)setBgColor:(SEColor *)bgColor
{
    if (bgColor) self.layer.backgroundColor = [bgColor CGColor];
    _bgColor = bgColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    ROUND_CGFLOAT(borderWidth);
    self.layer.borderWidth = borderWidth;
    _borderWidth = borderWidth;
}

- (void)setShadowColor:(SEColor *)shadowColor
{
    if (shadowColor) self.layer.shadowColor = [shadowColor CGColor];
    _shadowColor = shadowColor;
}

- (void)setShadowOffset:(SESize)shadowOffset
{
    CGSize s = SESizeMake(shadowOffset.width, shadowOffset.height);
    self.layer.shadowOffset = s;
    _shadowOffset = s;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = ZERO_TO_ONE(shadowOpacity);
    _shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    ROUND_CGFLOAT(shadowRadius);
    self.layer.shadowRadius = shadowRadius;
    _shadowRadius = shadowRadius;
}

#pragma mark - Image

- (void)loadImage_path:(NSString *)path duration:(NSTimeInterval)duration
{
    NSString *_path = [[NSBundle mainBundle] se_pathForResource:path];
//    NSAssert(_path, @"パスに画像がありません");
    SEImage *image = [[SEImage alloc] initWithContentsOfFile:_path];
//    NSAssert(image, @"画像がありません");
    id val;
#if TARGET_OS_IPHONE
    val = (id)[image CGImage];
#elif TARGET_OS_MAC
    val = image;
#endif
    if (val) {
        // レイヤのサイズが設定されていなかったら画像サイズにレイヤーの大きさを調整
        SESize s = self.layer.bounds.size;
        if (CGSizeEqualToSize(s, CGSizeZero)) {
            SESize is = image.size;
            [self animate_key:@"size" value:[NSValue se_ValueWithSize:is] duration:0 options:nil];
        }
        [self animate_key:@"contents" value:val duration:duration options:nil];
    }
}

- (void)clearImage_duration:(NSTimeInterval)duration
{
	[CATransaction begin];
    [CATransaction setAnimationDuration:ROUND_DOUBLE(duration)];
    self.layer.contents = nil;
    [CATransaction commit];
}

- (void)show
{
    self.layer.hidden = NO;
}

- (void)hide
{
    self.layer.hidden = YES;
}

- (void)toggle
{
    BOOL hidden = self.layer.hidden;
    self.layer.hidden = !hidden;
}

- (void)fadeIn_duration:(NSTimeInterval)duration
{
    self.layer.opacity = 0;
    [self show];
    [self animate_key:@"opacity" value:@1 duration:duration options:nil];
}

- (void)fadeOut_duration:(NSTimeInterval)duration
{
    [self _animate_key:@"opacity" value:@0 duration:duration options:nil completion:^{
        [self hide];
    }];
}

#pragma mark - Animations

- (void)begin_duration:(NSTimeInterval)duration options:(NSDictionary *)options
{
    _animationBegan = YES;
    CAAnimationGroup *a = (CAAnimationGroup*)addOptions([CAAnimationGroup animation], options);
    a.duration = ROUND_CGFLOAT(duration);
    a.fillMode = kCAFillModeForwards;
    if (a.repeatCount == HUGE_VALF) {
        _isRepeatingForever = YES;
    }
    _animationGroup = a;
}

- (void)chain
{
    _animationChainBegan = YES;
}

- (void)commit
{
    // Queueに貯めたアニメーションをグループ化して追加する
    if (_animationBegan) {
        [self addAnimation:_animationGroup forKey:kGroupedAnimationKey completion:NULL];
    }
    _animationBegan = NO;
    _animationChainBegan = NO;
    _animationGroup = nil;
}

- (void)stop
{
    [self.layer removeAllAnimations];
    [(SEBasicLayerClass*)self.holder setActiveAnimationCount:0];
}

- (void)pause
{
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0;
    self.layer.timeOffset = pausedTime;
}

- (void)resume
{
    self.layer.speed = 1.0f;
    self.layer.timeOffset = 0;
    CFTimeInterval pausedTime = self.layer.timeOffset;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

- (void)animate_key:(NSString *)key value:(id)value duration:(CFTimeInterval)duration options:(NSDictionary *)options
{
    [self _animate_key:key value:value duration:duration options:options completion:NULL];
}

- (void)do_animationName:(NSString *)animationName duration:(CFTimeInterval)duration
{
    NSDictionary *definition = [(SEBasicLayerClass*)self.holder definedAnimations][animationName];
    NSDictionary *animations = definition[@"animations"];
    NSDictionary *options = definition[@"options"];
    CAAnimationGroup *g  = [CAAnimationGroup animation];
    addOptions(g, options);
    duration = ROUND_CGFLOAT(duration);
    NSMutableArray *ma = [NSMutableArray arrayWithCapacity:animations.allKeys.count];
    [animations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        CABasicAnimation *a = [self animationWithKey:key value:obj duration:duration options:nil];
        [ma addObject:a];
    }];
    g.duration = duration;
    g.animations = ma;
    [self addAnimation:g forKey:kGroupedAnimationKey completion:NULL];
}

- (void)_animate_key:(NSString *)key value:(id)value duration:(CFTimeInterval)duration options:(NSDictionary *)options completion:(void(^)())completion
{
    CABasicAnimation *animation = [self animationWithKey:key value:value duration:duration options:options];
    duration = ROUND_DOUBLE(duration);
    if (!_animationBegan && duration == 0) {
        // durationが0ならばアニメーションはしない
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        [CATransaction setCompletionBlock:^{
            if (completion) completion();
        }];
        [self.layer setValue:animation.toValue forKeyPath:animation.keyPath];
        [CATransaction commit];
        return;
    }
    // アニメーションの合成中は個別の間隔は無視
    if (!_animationBegan) {
        animation.duration = duration;
    }
    animation.fillMode = kCAFillModeForwards;
    
    if (_animationBegan) {
        // アニメーションの合成ならばキューに貯める
        NSArray *as = _animationGroup.animations;
        if (as) {
            _animationGroup.animations = [as arrayByAddingObject:animation];
        }else{
            _animationGroup.animations = @[animation];
        }
    }else{
        // 通常の実行
        [self addAnimation:animation forKey:key completion:completion];
    }
}


- (void)addAnimation:(CAAnimation*)animation forKey:(NSString *)key completion:(void(^)())completion
{
    // レイヤーへのアニメーションが被らないようにUUIDを付ける
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    NSString *uuid = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *animationKey = [NSString stringWithFormat:@"%@-%@",key,uuid]; // translate-xxxxx
    [CATransaction begin];
    // サイクルアニメーションでない場合のみ、現在実行中のアニメーションの把握するためにholderに数を追加
    if (!_isRepeatingForever) {
        __weak SEBasicLayerClass *__holder = (SEBasicLayerClass*)self.holder;
        __holder.activeAnimationCount += 1;
        [CATransaction setCompletionBlock:^{
            __holder.activeAnimationCount -= 1;
        }];
    }
    // 終わったあとにアニメーションを剥がすため、先にプロパティを設定しておく
    if (!animation.autoreverses) {
        if ([animation isKindOfClass:[CAAnimationGroup class]]) {
            for (CABasicAnimation *a in [(CAAnimationGroup*)animation animations]) {
                [self.layer setValue:a.toValue forKeyPath:a.keyPath];
            }
        }else if ([animation isKindOfClass:[CABasicAnimation class]]){
            id val = [(CABasicAnimation*)animation toValue];
            id key = [(CABasicAnimation*)animation keyPath];
            [self.layer setValue:val forKeyPath:key];
        }
    }
    [self.layer addAnimation:animation forKey:animationKey];
    [CATransaction commit];
    // チェイン状態だったらアニメーションごとにwaitAnimation()する
    if (_animationChainBegan) {
        [self waitAnimation];
    }
}

- (id)toValueForKey:(NSString*)key value:(id)value
{
    // create animation
    if (KEY_IS(@"position")) {
        SEPoint point = CGPointFromObject(value);
        CGFloat _x = VALID_CGFLOAT(point.x) ? X(point.x) : self.layer.position.x;
        CGFloat _y = VALID_CGFLOAT(point.y) ? Y(point.y) : self.layer.position.y;
        CGPoint position = CGPointMake(_x, _y);
        return [NSValue se_valueWithPoint:position];
    }else if (KEY_IS(@"zPosition")){
        // z値だけは正規化できないので常にpx値
        CGFloat z = [value CGFloatValue];
        CGFloat _z = VALID_CGFLOAT(z) ? z : self.layer.zPosition;
        return @(_z);
    }else if (KEY_IS(@"size")){
        CGRect bounds = self.layer.bounds;
        CGSize size = CGSizeFromObject(value);
        SESize s = SESizeMake(ROUND_CGFLOAT(size.width), ROUND_CGFLOAT(size.height));
        bounds.size.width += s.width;
        bounds.size.height += s.height;
        return [NSValue se_valueWithRect:bounds];
    }else if (KEY_IS(@"translate")){
        SEPoint selfp = self.layer.position;
        SEPoint point = CGPointFromObject(value);
        CGFloat _x = ROUND_CGFLOAT(point.x);
        _x += NORM_POSITION ? selfp.x/VW : selfp.x;
        CGFloat _y = ROUND_CGFLOAT(point.y);
        // 座標を補正
#if TARGET_OS_IPHONE
        _y += NORM_POSITION ? 1 - selfp.y/VH : VH - selfp.y;
#else
        _y += NORM_POSITION ? selfp.y/VH : selfp.y;
#endif
        // transform.translateを使うと面倒なので加算してpositionのアニメーションにする
        return [self toValueForKey:@"position" value:[NSValue se_valueWithPoint:CGPointMake(_x, _y)]];
    }else if (KEY_IS(@"translateZ")){
        CGFloat _z = ROUND_CGFLOAT([value CGFloatValue]) + self.layer.zPosition;
        // 同じくzPositionのアニメーションにする
        return [self toValueForKey:@"zPosition" value:@(_z)];
    }else if (KEY_IS(@"scale")){
        CGFloat _ratio = ROUND_CGFLOAT([value CGFloatValue]);
        return @(_ratio);
    }else if (KEY_IS(@"rotate")){
        CGFloat _degree = RADIAN(ROUND_CGFLOAT([value CGFloatValue]));
        CGFloat rotationZ = [[self.layer valueForKeyPath:@"transform.rotation.z"] CGFloatValue];
        return @(_degree+rotationZ);
    }else if (KEY_IS(@"rotateX")){
        CGFloat _degree = RADIAN(ROUND_CGFLOAT([value CGFloatValue]));
        CGFloat rotationX = [[self.layer valueForKeyPath:@"transform.rotation.x"] CGFloatValue];
        return @(_degree+rotationX);
    }else if (KEY_IS(@"rotateY")){
        CGFloat _degree = RADIAN(ROUND_CGFLOAT([value CGFloatValue]));
        CGFloat rotationY = [[self.layer valueForKeyPath:@"transform.rotation.y"] CGFloatValue];
        return @(_degree+rotationY);
    }else if (KEY_IS(@"opacity")){
        CGFloat _opacity = ZERO_TO_ONE([value CGFloatValue]);
        return @(_opacity);
    }else if (KEY_IS(@"contents")){
        return value;
    }
    return nil;
}

- (NSString *)keyPathForKey:(NSString*)key
{
    if (KEY_IS(@"position")) {
        return @"position";
    }else if (KEY_IS(@"zPosition")){
        return @"zPosition";
    }else if (KEY_IS(@"size")){
        return @"bounds";
    }else if (KEY_IS(@"translate")){
        return @"position";
    }else if (KEY_IS(@"translateZ")){
        return @"zPosition";
    }else if (KEY_IS(@"scale")){
        return @"transform.scale";
    }else if (KEY_IS(@"rotate")){
        return @"transform.rotation.z";
    }else if (KEY_IS(@"rotateX")){
        return @"transform.rotation.x";
    }else if (KEY_IS(@"rotateY")){
        return @"transform.rotation.y";
    }else if (KEY_IS(@"opacity")){
        return @"opacity";
    }else if (KEY_IS(@"contents")){
        return @"contents";
    }
    return nil;
}

- (CABasicAnimation*)animationWithKey:(NSString*)key value:(id)value duration:(CFTimeInterval)duration options:(NSDictionary*)options
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.toValue = [self toValueForKey:key value:value];
    animation.keyPath = [self keyPathForKey:key];
    animation.fromValue = [self.layer valueForKeyPath:animation.keyPath];
    addOptions(animation, options);
    return animation ?: nil;
}

static CAAnimation * addOptions(CAAnimation *animation, NSDictionary *options)
{
    if ([options[@"repeatCount"] isKindOfClass:[NSNumber class]]) {
        float rc  = [options[@"repeatCount"] floatValue];
        // マイナス値でサイクルアニメーション
        if (rc < 0) {
            animation.repeatCount = HUGE_VALF;
        }else{
            animation.repeatCount = rc;
        }
    }
    
    if ([options[@"timing"] isKindOfClass:[NSString class]]) {
        NSString *tm = options[@"timing"];
        NSString *name = kCAMediaTimingFunctionDefault;
        if ([tm isEqualToString:@"linear"]) {
            name = kCAMediaTimingFunctionLinear;
        }else if ([tm isEqualToString:@"ease-in"]){
            name = kCAMediaTimingFunctionEaseIn;
        }else if ([tm isEqualToString:@"ease-out"]){
            name = kCAMediaTimingFunctionEaseOut;
        }else if ([tm isEqualToString:@"ease-in-ease-out"]){
            name = kCAMediaTimingFunctionEaseInEaseOut;
        }
        animation.timingFunction = [CAMediaTimingFunction functionWithName:name];
    }else if ([options[@"timingPoints"] isKindOfClass:[NSArray class]]){
        CGFloat p1x = ROUND_CGFLOAT([options[@"timingPoints"][0] CGFloatValue]);
        CGFloat p1y = ROUND_CGFLOAT([options[@"timingPoints"][1] CGFloatValue]);
        CGFloat p2x = ROUND_CGFLOAT([options[@"timingPoints"][2] CGFloatValue]);
        CGFloat p2y = ROUND_CGFLOAT([options[@"timingPoints"][3] CGFloatValue]);
        animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:(float)p1x :(float)p1y :(float)p2x :(float)p2y];
    }
    if ([options[@"repeatDuration"] isKindOfClass:[NSNumber class]]) {
        CFTimeInterval rd = [options[@"repeatDuration"] doubleValue];
        animation.repeatDuration = rd;
    }
    if ([options[@"removeOnCompletion"] isKindOfClass:[NSNumber class]]) {
        BOOL roc = [options[@"removeOnCompletion"] boolValue];
        animation.removedOnCompletion = roc;
    }
    if ([options[@"timeOffset"] isKindOfClass:[NSNumber class]]) {
        CFTimeInterval to = [options[@"timeOffset"] doubleValue];
        animation.timeOffset = to;
    }
    if ([options[@"autoreverses"] isKindOfClass:[NSNumber class]]) {
        BOOL ar = [options[@"autoreverses"] boolValue];
        animation.autoreverses = ar;
    }
    if ([options[@"duration"] isKindOfClass:[NSNumber class]]) {
        CFTimeInterval d = [options[@"duration"] doubleValue];
        animation.duration = d;
    }
    return animation;
}

@end

