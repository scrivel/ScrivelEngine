
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

@interface SEBasicLayerClass ()

@end

@implementation SEBasicLayerClass
{
    NSMutableDictionary *__layers;
}

#pragma makr - SEObjectClass

- (instancetype)initWithEngine:(ScrivelEngine *)engine classIdentifier:(NSString *)classIdentifier
{
    self = [super initWithEngine:engine classIdentifier:classIdentifier];
    __layers = [NSMutableDictionary new];
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
    if ([args isKindOfClass:[NSNumber class]]) {
        layer =  (SEBasicLayer*)[super new_args:@{@"index": args}];
    }else{
        layer = (SEBasicLayer*)[super new_args:args];
    }
    // 古いレイヤーを消す
    [self clear_index:layer.index];
    // 登録
    [__layers setObject:layer forKey:@(layer.index)];
    // レイヤーを追加
    [self.engine.rootView.layer addSublayer:layer.layer];
    return layer;
}

#pragma mark - SELayerClass

- (id)at_index:(NSUInteger)index
{
    return [self.layers objectForKey:@((unsigned int)index)];
}

- (void)clear_index:(NSUInteger)index
{
    [[[__layers objectForKey:@(index)] layer]removeFromSuperlayer];
    [__layers removeObjectForKey:@(index)];
}

- (NSDictionary *)layers
{
    return __layers;
}

@end

@interface SEBasicLayer()
{
    CAAnimationGroup *_animationGroup;
}
@end

@implementation SEBasicLayer

#pragma mark - Private

- (instancetype)initWithOpts:(NSDictionary *)options holder:(SEBasicObjectClass *)holder
{
    self = [super initWithOpts:options holder:holder];
    NSParameterAssert(options[@"index"]);
    _index = [options[@"index"] unsignedIntValue];
    // 実体はレイヤー
    _layer = [CALayer layer];
    _layer.position = SEPointMake(0.5, 0.5);
    return self ?: nil;
}

#pragma mark - Property

- (void)setAnchorPoint_x:(CGFloat)x y:(CGFloat)y
{
#if TARGET_OS_IPHONE
    CGFloat _y = 1 - y;
#else
    CGFloat _y = y;
#endif
	self.layer.anchorPoint = CGPointMake(x, _y);
}

- (void)setGravity_gravity:(NSString *)gravity
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
        if (CGSizeEqualToSize(self.layer.bounds.size, CGSizeZero)) {
            [self enqueuAnimationForKeyPath:@"bounds.size" toValue:[NSValue se_ValueWithSize:image.size] duration:0];
        }
        [self enqueuAnimationForKeyPath:@"contents" toValue:val duration:duration];
    }
}

- (void)clearImage_duration:(NSTimeInterval)duration
{
	[CATransaction begin];
    [CATransaction setAnimationDuration:ROUND_DOUBLE(duration)];
    self.layer.contents = nil;
    [CATransaction commit];
}

#pragma mark - Appearence

- (void)bg_color:(NSString *)color
{
    SEColor *hex = [SEColorUtil colorWithHEXString:color];
    if (hex) self.layer.backgroundColor = [hex CGColor];
}

- (void)border_width:(CGFloat)width color:(NSString *)color
{
    if VALID_CGFLOAT(width) self.layer.borderWidth = width;
    SEColor *hex = [SEColorUtil colorWithHEXString:color];
    if (hex) self.layer.borderColor = [hex CGColor];
}

- (void)shadowColor_color:(NSString *)color
{
    SEColor *hex  = [SEColorUtil colorWithHEXString:color];
    if (hex) self.layer.shadowColor = [hex CGColor];
}

- (void)shadowOffset_x:(CGFloat)x y:(CGFloat)y
{
    CGFloat _x = VALID_CGFLOAT(x) ? x : self.layer.shadowOffset.width;
    CGFloat _y = VALID_CGFLOAT(y) ? y : self.layer.shadowOffset.height;
    CGSize s = SESizeMake(_x, _y);
    self.layer.shadowOffset = s;
}

- (void)shadowOpcity_opacity:(CGFloat)opacity
{
    self.layer.shadowOpacity = ZERO_TO_ONE(opacity);
}

- (void)shadowRadius_radius:(CGFloat)radius
{
    if VALID_CGFLOAT(radius) self.layer.shadowRadius = radius;
}

#pragma mark - Animations

- (void)enqueuAnimationForKeyPath:(NSString *)keyPath toValue:(id)value duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:keyPath toValue:value duration:duration completion:NULL];
}

- (void)enqueuAnimationForKeyPath:(NSString *)keyPath
                          toValue:(id)toValue
                         duration:(NSTimeInterval)duration
                       completion:(void(^)())completion
{
    NSParameterAssert(keyPath != nil);
    NSParameterAssert(toValue != nil);
    NSParameterAssert(duration >= 0);
    duration = ROUND_DOUBLE(duration);
    if (!_animationBegan && duration == 0) {
        // durationが0ならばアニメーションはしない
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        [CATransaction setCompletionBlock:^{
            if (completion) completion();
        }];
        [self.layer setValue:toValue forKeyPath:keyPath];
        [CATransaction commit];
        return;
    }
    // アニメーションを作成
    id val = [self.layer valueForKeyPath:keyPath];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    // アニメーションの合成中は個別の間隔は無視
    if (!_animationBegan) {
        animation.duration = duration;
    }
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = val;
    animation.toValue = toValue;
    
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
        [self addAnimation:animation forKey:keyPath completion:completion];
    }
}

- (void)addAnimation:(CAAnimation*)animation forKey:(NSString *)key completion:(void(^)())completion
{
    NSParameterAssert(animation != nil);
    NSParameterAssert(key != nil);
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

- (void)beginAnimation_duration:(NSTimeInterval)duration options:(NSDictionary *)options
{
    _animationBegan = YES;
    CAAnimationGroup *a = [CAAnimationGroup animation];
    a.duration = ROUND_CGFLOAT(duration);
    a.fillMode = kCAFillModeForwards;
    if ([options[@"repeatCount"] isKindOfClass:[NSNumber class]]) {
        float rc  = [options[@"repeatCount"] floatValue];
        // マイナス値でサイクルアニメーション
        if (rc < 0) {
            a.repeatCount = HUGE_VALF;
        }else{
            a.repeatCount = rc;
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
        a.timingFunction = [CAMediaTimingFunction functionWithName:name];
    }else if ([options[@"timingPoints"] isKindOfClass:[NSArray class]]){
        CGFloat p1x = ROUND_CGFLOAT([options[@"timingPoints"][0] CGFloatValue]);
        CGFloat p1y = ROUND_CGFLOAT([options[@"timingPoints"][1] CGFloatValue]);
        CGFloat p2x = ROUND_CGFLOAT([options[@"timingPoints"][2] CGFloatValue]);
        CGFloat p2y = ROUND_CGFLOAT([options[@"timingPoints"][3] CGFloatValue]);
        a.timingFunction = [CAMediaTimingFunction functionWithControlPoints:(float)p1x :(float)p1y :(float)p2x :(float)p2y];
    }
    if ([options[@"repeatDuration"] isKindOfClass:[NSNumber class]]) {
        CFTimeInterval rd = [options[@"repeatDuration"] doubleValue];
        a.repeatDuration = rd;
    }
    if ([options[@"removeOnCompletion"] isKindOfClass:[NSNumber class]]) {
        BOOL roc = [options[@"removeOnCompletion"] boolValue];
        a.removedOnCompletion = roc;
    }
    if ([options[@"timeOffset"] isKindOfClass:[NSNumber class]]) {
        CFTimeInterval to = [options[@"timeOffset"] doubleValue];
        a.timeOffset = to;
    }
    if ([options[@"autoreverses"] isKindOfClass:[NSNumber class]]) {
        BOOL ar = [options[@"autoreverses"] boolValue];
        a.autoreverses = ar;
    }
    if ([options[@"duration"] isKindOfClass:[NSNumber class]]) {
        CFTimeInterval d = [options[@"duration"] doubleValue];
        a.duration = d;
    }
    if (a.repeatCount == HUGE_VALF) {
        _isRepeatingForever = YES;
    }
    _animationGroup = a;
}

- (void)chainAnimation
{
    _animationChainBegan = YES;
}

- (void)commitAnimation
{
    // Queueに貯めたアニメーションをグループ化して追加する
    if (_animationBegan) {
        [self addAnimation:_animationGroup forKey:kGroupedAnimationKey completion:NULL];
    }
    _animationBegan = NO;
    _animationChainBegan = NO;
    _animationGroup = nil;
}

- (void)position_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    CGFloat _x = VALID_CGFLOAT(x) ? X(x) : self.layer.position.x;
    CGFloat _y = VALID_CGFLOAT(y) ? Y(y) : self.layer.position.y;
    CGPoint position = CGPointMake(_x, _y);
    NSValue *v = [NSValue se_valueWithPoint:position];
    [self enqueuAnimationForKeyPath:@"position" toValue:v duration:duration];
}

- (void)zPosition_z:(CGFloat)z duration:(NSTimeInterval)duration
{
    // z値だけは正規化できないので常にpx値
    CGFloat _z = VALID_CGFLOAT(z) ? z : self.layer.zPosition;
    [self enqueuAnimationForKeyPath:@"zPosition" toValue:@(_z) duration:duration];
}

- (void)size_width:(CGFloat)width height:(CGFloat)height duration:(NSTimeInterval)duration
{
    CGRect bounds = self.layer.bounds;
    SESize s = SESizeMake(ROUND_CGFLOAT(width), ROUND_CGFLOAT(height));
    bounds.size.width += s.width;
    bounds.size.height += s.height;
    NSValue *v = [NSValue se_valueWithRect:bounds];
	[self enqueuAnimationForKeyPath:@"bounds" toValue:v duration:duration];
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
    [self show];
    [self opacity_ratio:1 duration:duration];
}

- (void)fadeOut_duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"opacity" toValue:@(0) duration:duration completion:^{
        [self hide];
    }];
}

- (void)translate_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    SEPoint p = self.layer.position;
    CGFloat _x = ROUND_CGFLOAT(x);
    _x += NORM_POSITION ? p.x/VW : p.x;
    CGFloat _y = ROUND_CGFLOAT(y);
    // 座標を補正
#if TARGET_OS_IPHONE
    _y += NORM_POSITION ? 1 - p.y/VH : VH - p.y;
#else
    _y += NORM_POSITION ? p.y/VH : p.y;
#endif
    // transform.translateを使うと面倒なので加算してpositionのアニメーションにする
    [self position_x:_x y:_y duration:duration];
}

- (void)translateZ_z:(CGFloat)z duration:(NSTimeInterval)duration
{
    CGFloat _z = ROUND_CGFLOAT(z) + self.layer.zPosition;
    [self zPosition_z:_z duration:duration];
}

- (void)scale_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
    CGFloat _ratio = ROUND_CGFLOAT(ratio);
	[self enqueuAnimationForKeyPath:@"transform.scale" toValue:@(_ratio) duration:duration];
}

- (void)rotate_degree:(CGFloat)degree duration:(NSTimeInterval)duration
{
    CGFloat _degree = RADIAN(ROUND_CGFLOAT(degree));
    CGFloat rotationZ = [[self.layer valueForKeyPath:@"transform.rotation.z"] CGFloatValue];
    [self enqueuAnimationForKeyPath:@"transform.rotation.z" toValue:@(_degree+rotationZ) duration:duration];
}

- (void)rotateX_degree:(CGFloat)degree duration:(NSTimeInterval)duration
{
    CGFloat _degree = RADIAN(ROUND_CGFLOAT(degree));
    CGFloat rotationX = [[self.layer valueForKeyPath:@"transform.rotation.x"] CGFloatValue];
    [self enqueuAnimationForKeyPath:@"transform.rotation.x" toValue:@(_degree+rotationX) duration:duration];
}

- (void)rotateY_degree:(CGFloat)degree duration:(NSTimeInterval)duration
{
    CGFloat _degree = RADIAN(ROUND_CGFLOAT(degree));
    CGFloat rotationY = [[self.layer valueForKeyPath:@"transform.rotation.y"] CGFloatValue];
    [self enqueuAnimationForKeyPath:@"transform.rotation.y" toValue:@(_degree+rotationY) duration:duration];
}

- (void)opacity_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
    NSParameterAssert(VALID_CGFLOAT(ratio));
    [self enqueuAnimationForKeyPath:@"opacity" toValue:@(ZERO_TO_ONE(ratio)) duration:duration];
}


@end

