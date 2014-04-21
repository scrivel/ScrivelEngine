
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

#define kLayerTypeBackground @"background"
#define kLayerTypeContent @"content"
#define kLayerTypeForeGround @"foreground"

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

- (id)init
{
    __layers = [NSMutableDictionary new];
    __definedAnimations = [NSMutableDictionary new];
    return [super init];
}

- (Class)instanceClass
{
    return [SEBasicLayer class];
}

- (void)setActiveAnimationCount:(NSUInteger)activeAnimationCount
{
    _activeAnimationCount = activeAnimationCount;
    // 実行中のアニメーションがすべて終了したら通知を出す
    if (activeAnimationCount == 0) {
        [self kx_emit:SEAnimationCompletionEvent userInfo:nil center:self.engine.notificationCenter];
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
    if (!layer.added) {
        layer.index = (unsigned int)self.engine.rootView.layer.sublayers.count;
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
    SEBasicLayer *layer = [__layers objectForKey:key];
    [layer.layer removeFromSuperlayer];
    [__layers removeObjectForKey:key];
}

- (void)clearAll
{
    for (SEBasicLayer *l in __layers.objectEnumerator) {
        [[l layer] removeFromSuperlayer];
    }
    [__layers removeAllObjects];
}

- (void)defineAnimation_name:(id<NSCopying>)name animations:(NSDictionary *)animations options:(NSDictionary *)options
{
    [__definedAnimations setObject:@{@"animations": animations, @"options" : options} forKey:name];
}

@end

@implementation SEBasicLayer
{
    NSString *_gravity;
    SEPoint _anchorPoint;
    CGFloat _borderWidth;
    SEColor *_bgColor;
    SEColor *_borderColor;
    SEColor *_shadowColor;
    CGFloat _shadowOpacity;
    CGFloat _shadowRadius;
    SESize _shadowOffset;
    NSString *_layerType;
}

@synthesize gravity = _gravity;
@synthesize anchorPoint = _anchorPoint;
@synthesize bgColor = _bgColor;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowOffset = _shadowOffset;
@synthesize layerType = _layerType;

#pragma mark - Private

#define KEY_IS(k) [key isEqualToString:k]

- (instancetype)init
{
    _isChaining = NO;
    _isRepeatingForever = NO;
    _layer = [CALayer layer];
    return [super init];
}

- (void)didMoveToSuperLayer:(CALayer*)layer
{
    self.layer.position = SEPointFromArray(@[@"50%",@"50%"], VIEW_SIZE, VIRTUAL_SIZE);
}

#pragma mark - Property

- (void)set_key:(NSString *)key value:(id)value
{
    if (KEY_IS(@"index")){
        [self setIndex:[value unsignedIntValue]];
    }else if (KEY_IS(@"anchorPoint")) {
        [self setAnchorPoint:CGPointFromObject(value)];
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
        [self setShadowOffset:SESizeFromObject(value, VIEW_SIZE, VIRTUAL_SIZE)];
    }else if (KEY_IS(@"layerType")){
        [self setLayerType:value];
    }else if (KEY_IS(@"image")){
        [self loadImage_path:value];
    }else if (KEY_IS(@"key")){
        [self setKey:value];
    }else{
        [super set_key:key value:value];
    }
}

- (void)setIndex:(unsigned int)index
{
    [self.layer removeFromSuperlayer];
    [self.engine.rootView.layer insertSublayer:self.layer atIndex:index];
    _index = index;
}

- (BOOL)added
{
    return self.layer.superlayer ? YES : NO;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
#if TARGET_OS_IPHONE
    anchorPoint.y = 1 - anchorPoint.y;
    self.layer.anchorPoint = anchorPoint;
#else
    self.layer.anchorPoint = anchorPoint;
#endif
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
    self.layer.shadowOffset = shadowOffset;
    _shadowOffset = shadowOffset;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = SENormalize(shadowOpacity);
    _shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    ROUND_CGFLOAT(shadowRadius);
    self.layer.shadowRadius = shadowRadius;
    _shadowRadius = shadowRadius;
}

#pragma mark - Image

- (void)loadImage_path:(NSString *)path
{
    NSString *_path = [self.engine pathForResource:path];
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
            [self animate_animations:@{@"size": [NSValue se_valueWithSize:is]} options:nil];
        }
        self.layer.contents = val;
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
    [self animate_animations:@{@"opacity": @1} options:@{@"duration": @(duration)}];
}

- (void)fadeOut_duration:(NSTimeInterval)duration
{
    __weak typeof(self) __self = self;
    [self _animate_animations:@{@"opacity": @0} options:@{@"duration": @(duration)} completion:^{
        [__self hide];
    }];
}

#pragma mark - Animations

- (void)chain
{
    _isChaining = YES;
}

- (void)commit
{
    _isChaining = NO;
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

- (void)animate_animations:(NSDictionary *)animations options:(NSDictionary *)options
{
    [self _animate_animations:animations options:options completion:NULL];
}

- (void)do_animationName:(NSString *)animationName duration:(CFTimeInterval)duration
{
    NSDictionary *definition = [(SEBasicLayerClass*)self.holder definedAnimations][animationName];
    NSDictionary *animations = definition[@"animations"];
    NSMutableDictionary *options = [definition[@"options"] mutableCopy];
    options[@"duration"] = @(duration);
    [self animate_animations:animations options:options];
}

- (void)_animate_animations:(NSDictionary *)animations options:(NSDictionary *)options completion:(void(^)())completion
{
    // 複数のアニメーションを合成する
    CAAnimationGroup *g  = [CAAnimationGroup animation];
    addOptions(g, options);
    CFTimeInterval duration = [options[@"duration"] doubleValue];
    if (duration == 0) {
        [animations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:0];
            [self.layer setValue:[self toValueForKey:key value:obj] forKeyPath:[self keyPathForKey:key]];
            [CATransaction commit];
        }];
    }else if(duration > 0){
        NSMutableArray *ma = [NSMutableArray arrayWithCapacity:animations.allKeys.count];
        [animations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            CABasicAnimation *a = [self animationWithKey:key value:obj duration:duration options:nil];
            [ma addObject:a];
        }];
        g.animations = ma;
        if (g.repeatCount == HUGE_VALF) {
            _isRepeatingForever = YES;
        }
        [self addAnimation:g forKey:kGroupedAnimationKey completion:completion];
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
    // エンジンの実行スピードに合わせる
    animation.duration = ACTUAL_DURATION(animation.duration);
    [self.layer addAnimation:animation forKey:animationKey];
    [CATransaction commit];
    // チェイン状態だったらアニメーションごとにwaitAnimation()する
    if (_isChaining) {
        [self waitAnimation];
    }
}

- (id)toValueForKey:(NSString*)key value:(id)value
{
    // create animation
    if (KEY_IS(@"position")) {
        SEPoint point = SEPointFromObject(value, VIEW_SIZE, VIRTUAL_SIZE);
        return [NSValue se_valueWithPoint:point];
    }else if (KEY_IS(@"zPosition")){
        // z値だけは正規化できないので常にpx値
        CGFloat z = [[SEUnitValueMake(value) numberValue] CGFloatValue];
        return @(z);
    }else if (KEY_IS(@"size")){
        CGRect bounds = self.layer.bounds;
        SESize size = SESizeFromObject(value, VIEW_SIZE, VIRTUAL_SIZE);
        bounds.size.width = size.width;
        bounds.size.height = size.height;
        return [NSValue se_valueWithRect:bounds];
    }else if (KEY_IS(@"translate")){
        SEVector translation = SEVectorFromObject(value, VIEW_SIZE, VIRTUAL_SIZE);
        SEPoint position = self.layer.position;
        position.x += translation.dx;
        position.y += translation.dy;
        return [NSValue se_valueWithPoint:position];
    }else if (KEY_IS(@"translateZ")){
        CGFloat z = [[SEUnitValueMake(value) numberValue] CGFloatValue];
        CGFloat zp = self.layer.zPosition;
        zp += z;
        // 同じくzPositionのアニメーションにする
        return @(zp);
    }else if (KEY_IS(@"scale")){
        CGFloat _ratio = ROUND_CGFLOAT([value CGFloatValue]);
        return @(_ratio);
    }else if (KEY_IS(@"rotate")){
        CGFloat _degree = SEMakeRadian(ROUND_CGFLOAT([value CGFloatValue]));
        CGFloat rotationZ = [[self.layer valueForKeyPath:@"transform.rotation.z"] CGFloatValue];
        return @(_degree+rotationZ);
    }else if (KEY_IS(@"rotateX")){
        CGFloat _degree = SEMakeRadian(ROUND_CGFLOAT([value CGFloatValue]));
        CGFloat rotationX = [[self.layer valueForKeyPath:@"transform.rotation.x"] CGFloatValue];
        return @(_degree+rotationX);
    }else if (KEY_IS(@"rotateY")){
        CGFloat _degree = SEMakeRadian(ROUND_CGFLOAT([value CGFloatValue]));
        CGFloat rotationY = [[self.layer valueForKeyPath:@"transform.rotation.y"] CGFloatValue];
        return @(_degree+rotationY);
    }else if (KEY_IS(@"opacity")){
        CGFloat _opacity = SENormalize([value CGFloatValue]);
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
    animation.fillMode = kCAFillModeForwards;
    animation.duration = ROUND_CGFLOAT(duration);
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

