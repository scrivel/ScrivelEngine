
//
//  _SEConcretLayer.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicLayer.h"
#import "NSValue+ScrivelEngine.h"
#import "ScrivelEngine.h"
#import "SEMethod.h"
#import "AVHexColor.h"
#import "NSBundle+ScrivelEngine.h"

#define kMaxLayer 1000
#define kGroupedAnimationKey @"GroupedAnimation"
#define VALID_DOUBLE(d) (d != SENilDouble)
#define ROUND_DOUBLE(d) (VALID_DOUBLE(d) ? d : 0.0)
#define VALID_INT(i) (i != SENilInteger)

static inline CGFloat NORMALIZED(CGFloat f)
{
    CGFloat _f = ROUND_DOUBLE(f);
    if (_f < 0) {
        return 0.0;
    }else if (_f > 1){
        return 1.0;
    }
    return _f;
}
static NSMutableDictionary *layers;

@interface SEBasicLayer()
{
    BOOL _animationBegan;
    CAAnimationGroup *_animationGroup;
}

@property (nonatomic, weak) ScrivelEngine *engine;

@end

@implementation SEBasicLayer

+ (void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // レイヤーを初期化
        layers = [NSMutableDictionary dictionaryWithCapacity:kMaxLayer];
    });
}

+ (NSDictionary *)layers
{
    return layers;
}

#pragma mark - Private


- (instancetype)initWithOpts:(NSDictionary *)options
{
    self = [super initWithOpts:options];
    NSParameterAssert(options[@"index"]);
    _index = [options[@"index"] unsignedIntValue];
    // 実体はレイヤー
    _layer = [CALayer layer];
    return self ?: nil;
}

- (NSString *)description
{
    return [self.layer description];
}

#pragma mark - SEObject

+ (id)callStatic_method:(SEMethod *)method engine:(ScrivelEngine *)engine
{
    Class<SEClassProxy> proxy = [engine classProxyClass];
    SEL sel = [proxy selectorForMethodIdentifier:method.name];
    if (sel == @selector(new_args:)) {
        SEBasicLayer *new = [self new_args:[method argAtIndex:0]];
        CALayer *current = [[layers objectForKey:@(new.index)] layer];
        if (current) {
            [engine.rootView.layer replaceSublayer:current with:new.layer];
        }else{
            [engine.rootView.layer insertSublayer:new.layer atIndex:new.index];
        }
        [layers setObject:new forKey:@(new.index)];
        return new;
    }else if (sel == @selector(at_index:)){
        return [self at_index:(unsigned int)[method integerArgAtIndex:0]];
    }
    @throw [NSString stringWithFormat:@"存在しないメソッド : %@",method];
    return nil;
}

- (id)callInstance_method:(SEMethod *)method engine:(ScrivelEngine *)engine
{
    self.engine = engine;
    Class<SEClassProxy> proxy = [engine classProxyClass];
    SEL sel = [proxy selectorForMethodIdentifier:method.name];
    if (!sel || ![self respondsToSelector:sel]) {
        @throw [NSString stringWithFormat:@"存在しないメソッド : %@",method];
        return nil;
    }else if (sel == @selector(setAnchorPoint_x:y:)) {
        [self setAnchorPoint_x:[method doubleArgAtIndex:0] y:[method doubleArgAtIndex:1]];
    }else if (sel == @selector(setPositionType_type:)) {
        [self setPositionType_type:[method argAtIndex:0]];
    }else if (sel == @selector(loadImage_path:duration:)) {
        [self loadImage_path:[method argAtIndex:0] duration:[method doubleArgAtIndex:1]];
    }else if (sel == @selector(clearImage_duration:)) {
        [self clearImage_duration:[method doubleArgAtIndex:0]];
    }else if (sel == @selector(clear)) {
        [self clear];
    }else if (sel == @selector(bg_color:)) {
        [self bg_color:[method argAtIndex:0]];
    }else if (sel == @selector(border_width:color:)) {
        [self border_width:[method doubleArgAtIndex:0] color:[method argAtIndex:1]];
    }else if (sel == @selector(shadowOffset_x:y:)) {
        [self shadowOffset_x:[method doubleArgAtIndex:0] y:[method doubleArgAtIndex:1]];
    }else if (sel == @selector(shadowColor_color:)) {
        [self shadowColor_color:[method argAtIndex:0]];
    }else if (sel == @selector(shadowRadius_radius:)) {
        [self shadowRadius_radius:[method doubleArgAtIndex:0]];
    }else if (sel == @selector(shadowOpcity_opacity:)) {
        [self shadowOpcity_opacity:[method doubleArgAtIndex:0]];
    }else if (sel == @selector(beginAnimation_duration:)) {
        [self beginAnimation_duration:[method doubleArgAtIndex:0]];
    }else if (sel == @selector(commitAnimation)) {
        [self commitAnimation];
    }else if (sel == @selector(position_x:y:duration:)) {
        [self position_x:[method doubleArgAtIndex:0]
                       y:[method doubleArgAtIndex:1]
                duration:[method doubleArgAtIndex:2]];
    }else if (sel == @selector(zPosition_z:duration:)) {
        [self zPosition_z:[method doubleArgAtIndex:0]
                 duration:[method doubleArgAtIndex:1]];
    }else if (sel == @selector(size_width:height:duration:)) {
        [self size_width:[method doubleArgAtIndex:0]
                  height:[method doubleArgAtIndex:1]
                duration:[method doubleArgAtIndex:2]];
    }else if (sel == @selector(show)) {
        [self show];
    }else if (sel == @selector(hide)) {
        [self hide];
    }else if (sel == @selector(toggle)) {
        [self toggle];
    }else if (sel == @selector(fadeIn_duration:)){
        [self fadeIn_duration:[method doubleArgAtIndex:0]];
    }else if (sel == @selector(fadeOut_duration:)){
        [self fadeOut_duration:[method doubleArgAtIndex:0]];
    }else if (sel == @selector(translate_x:y:duration:)){
        [self translate_x:[method doubleArgAtIndex:0] y:[method doubleArgAtIndex:1] duration:[method doubleArgAtIndex:2]];
    }else if (sel == @selector(translateZ_z:duration:)){
        [self translateZ_z:[method doubleArgAtIndex:0] duration:[method doubleArgAtIndex:0]];
    }else if (sel == @selector(scale_ratio:duration:)) {
        [self scale_ratio:[method doubleArgAtIndex:0]
                 duration:[method doubleArgAtIndex:1]];
    }else if (sel == @selector(rotate_degree:duration:)) {
        [self rotate_degree:[method doubleArgAtIndex:0]
                   duration:[method doubleArgAtIndex:1]];
    }else if (sel == @selector(opacity_ratio:duration:)){
        [self opacity_ratio:[method doubleArgAtIndex:0]
                   duration:[method doubleArgAtIndex:1]];
    }
    self.engine = nil;
    return self;
}

#pragma mark - SELayer

#pragma mark - Static

+ (instancetype)new_args:(id)args
{
    if ([args isKindOfClass:[NSNumber class]]) {
        // layer.new(1)のような形式
        return [[self alloc] initWithOpts:@{@"index": args}];
    }
    return [[self alloc] initWithOpts:args];
}

+ (id)at_index:(unsigned int)index
{
    return  layers[@(index)];
}

#pragma mark - Property

- (void)setAnchorPoint_x:(CGFloat)x y:(CGFloat)y
{
	self.layer.anchorPoint = CGPointMake(x, y);
}

- (void)setPositionType_type:(NSString *)type
{
    if ([type isEqualToString:@"px"]) {
        _positionType = SELayerPositionTypePX;
    }else if ([type isEqualToString:@"normalized"]){
        _positionType = SELayerPositionTypeNormalized;
    }
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
    NSAssert(_path, @"パスに画像がありません");
    SEImage *image = [[SEImage alloc] initWithContentsOfFile:_path];
    NSAssert(image, @"画像がありません");
    id val;
#if TARGET_OS_IPHONE
    val = (id)[image CGImage];
#elif TARGET_OS_MAC
    val = image;
#endif
    [self enqueuAnimationForKeyPath:@"contents" toValue:val duration:duration];
}

- (void)clearImage_duration:(NSTimeInterval)duration
{
	[CATransaction begin];
    [CATransaction setAnimationDuration:ROUND_DOUBLE(duration)];
    self.layer.contents = nil;
    [CATransaction commit];
}

- (void)clear
{
	[self.layer removeFromSuperlayer];
    [layers removeObjectForKey:@(self.index)];
}

#pragma mark - Appearence

- (void)bg_color:(NSString *)color
{
    AVColor *hex = [AVHexColor colorWithHexString:color];
    NSAssert(hex, @"色が指定されていない");
    self.layer.backgroundColor = [hex CGColor];
}

- (void)border_width:(CGFloat)width color:(NSString *)color
{
    if VALID_DOUBLE(width) self.layer.borderWidth = width;
    AVColor *hex = [AVHexColor colorWithHexString:color];
    if (hex) self.layer.borderColor = [hex CGColor];
}

- (void)shadowColor_color:(NSString *)color
{
    AVColor *hex  = [AVHexColor colorWithHexString:color];
    if (hex) self.layer.shadowColor = [hex CGColor];
}

- (void)shadowOffset_x:(CGFloat)x y:(CGFloat)y
{
    CGFloat _x = VALID_DOUBLE(x) ? x : self.layer.shadowOffset.width;
    CGFloat _y = VALID_DOUBLE(y) ? y : self.layer.shadowOffset.height;
    CGSize s = CGSizeMake(_x, _y);
    self.layer.shadowOffset = s;
}

- (void)shadowOpcity_opacity:(CGFloat)opacity
{
    self.layer.shadowOpacity = NORMALIZED(opacity);
}

- (void)shadowRadius_radius:(CGFloat)radius
{
    if VALID_DOUBLE(radius) self.layer.shadowRadius = radius;
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
    // 対応するキーはちゃんとあるか？
    id val = [self.layer valueForKeyPath:keyPath];
//    NSAssert(val, @"keyPathが間違ってる");
    // アニメーションを作成
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    // アニメーションの合成中は個別の間隔は無視
    if (!_animationBegan) {
        animation.duration = duration;
    }
    // 元に戻さない
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
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
#if TARGET_OS_IPHONE
    // UIView.layerだとこれを挟まないと正常に動作しないことがある
    [UIView beginAnimations:animationKey context:nil];
#endif
    if ([animation isKindOfClass:[CAAnimationGroup class]]) {
        for (CABasicAnimation *a in [(CAAnimationGroup*)animation animations]) {
            NSLog(@"%@ : %@",a.keyPath, [self.layer valueForKeyPath:a.keyPath]);
            [self.layer setValue:a.toValue forKeyPath:a.keyPath];
            NSLog(@"%@ : %@",a.keyPath, [self.layer valueForKeyPath:a.keyPath]);
        }
    }else if ([animation isKindOfClass:[CABasicAnimation class]]){
        id val = [(CABasicAnimation*)animation toValue];
        id key = [(CABasicAnimation*)animation keyPath];
        [self.layer setValue:val forKeyPath:key];
    }
    [CATransaction begin];
    // アニメーションを逐次実行するためにRunLoopでブロックする
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    CFDateRef distantFuture = (__bridge CFDateRef)[NSDate distantFuture];
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(NULL, CFDateGetAbsoluteTime(distantFuture), 0, 0, 0, NULL, NULL);
    CFRunLoopAddTimer(rl, timer, kCFRunLoopDefaultMode);
    [CATransaction setCompletionBlock:^{
        // アニメーションの終了後にプロパティの値を書き換える
        CFRunLoopStop(rl);
        CFRunLoopTimerInvalidate(timer);
        CFRelease(timer);
        if (completion) completion();
    }];
    [self.layer addAnimation:animation forKey:animationKey];
    [CATransaction commit];
#if TARGET_OS_IPHONE
    [UIView commitAnimations];
#endif
    CFRunLoopRun();
}


- (void)beginAnimation_duration:(NSTimeInterval)duration
{
    _animationBegan = YES;
////    NSAssert(duration > 0, @"durationが0以下");
    CAAnimationGroup *g = [CAAnimationGroup animation];
    g.duration = duration;
    g.repeatCount = 1;
    g.removedOnCompletion = NO;
    g.fillMode = kCAFillModeForwards;
    _animationGroup = g;
}

- (void)commitAnimation
{
    // Queueに貯めたアニメーションをグループ化して追加する
    NSAssert(_animationBegan, @"beginAnimationが呼ばれていない");
    NSAssert(_animationGroup.animations.count > 0, @"アニメーションが追加されていない");
    [self addAnimation:_animationGroup forKey:kGroupedAnimationKey completion:NULL];
    _animationBegan = NO;
    _animationGroup = nil;
}

- (void)position_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    CGFloat _x = VALID_DOUBLE(x) ? x : self.layer.position.x;
    CGFloat _y = VALID_DOUBLE(y) ? y : self.layer.position.y;
    CGPoint position = CGPointMake(_x, _y);
    NSValue *v = [NSValue se_valueWithPoint:position];
    [self enqueuAnimationForKeyPath:@"position" toValue:v duration:duration];
}

- (void)zPosition_z:(CGFloat)z duration:(NSTimeInterval)duration
{
    CGFloat _z = VALID_DOUBLE(z) ? z : self.layer.zPosition;
    [self enqueuAnimationForKeyPath:@"zPosition" toValue:@(_z) duration:duration];
}

- (void)size_width:(CGFloat)width height:(CGFloat)height duration:(NSTimeInterval)duration
{
    CGRect bounds = self.layer.bounds;
    if VALID_DOUBLE(width) bounds.size.width = width;
    if VALID_DOUBLE(height) bounds.size.height = height;
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
    [self enqueuAnimationForKeyPath:@"opacity" toValue:@(0) duration:ROUND_DOUBLE(duration) completion:^{
        [self hide];
        NSLog(@"hidden!");
    }];
}

- (void)translate_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    CGFloat _x = ROUND_DOUBLE(x) + self.layer.position.x;
    CGFloat _y = ROUND_DOUBLE(y) + self.layer.position.y;
    // transform.translateを使うと面倒なので加算してpositionのアニメーションにする
    [self position_x:_x y:_y duration:duration];
}

- (void)translateZ_z:(CGFloat)z duration:(NSTimeInterval)duration
{
    CGFloat _z = ROUND_DOUBLE(z) + self.layer.zPosition;
    [self zPosition_z:_z duration:duration];
}

- (void)scale_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
    NSParameterAssert(VALID_DOUBLE(ratio));
	[self enqueuAnimationForKeyPath:@"transform.scale" toValue:@(ratio) duration:duration];
}

- (void)rotate_degree:(CGFloat)degree duration:(NSTimeInterval)duration
{
    NSParameterAssert(VALID_DOUBLE(degree));
    CGFloat _degree = degree*(M_PI/180.0);
    CGFloat rotationZ = [[self.layer valueForKeyPath:@"transform.rotation.z"] doubleValue];
    [self enqueuAnimationForKeyPath:@"transform.rotation.z" toValue:@(_degree+rotationZ) duration:duration];
}

- (void)opacity_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
    NSParameterAssert(VALID_DOUBLE(ratio));
    [self enqueuAnimationForKeyPath:@"opacity" toValue:@(NORMALIZED(ratio)) duration:duration];
}


@end

