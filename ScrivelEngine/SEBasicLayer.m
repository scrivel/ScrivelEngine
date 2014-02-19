
//
//  _SEConcretLayer.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicLayer.h"

#define kMaxLayer 1000
#define kGroupedAnimationKey @"GroupedAnimation"

static NSMutableArray *layers;

@implementation SEBasicLayer
{
    BOOL _animationBegan;
    CAAnimationGroup *_animationGroup;
}

+ (void)load
{
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // レイヤーを初期化
        layers = [NSMutableArray arrayWithCapacity:kMaxLayer];
        for (NSUInteger i = 0; i < kMaxLayer; i++) {
            layers[i] = [NSNull null];
        }
    });
}

#pragma mark - Private


- (instancetype)initWithOpts:(NSDictionary *)options
{
    self = [super initWithOpts:options];
    NSParameterAssert(options[@"index"]);
    _index = [options[@"index"] unsignedIntegerValue];
    // レイヤーに追加∫
    [layers replaceObjectAtIndex:_index withObject:self];
    return self ?: nil;
}

- (CALayer *)layer
{
    @throw @"NEEDS OVERRIDE";
}

#pragma mark - SELayer

#pragma mark - Static

+ (instancetype)new_options:(NSDictionary *)options
{
	return [[self alloc] initWithOpts:options];
}

+ (id)at_index:(NSUInteger)index
{
    id layer = layers[index];
    return (layer != [NSNull null]) ? layers : nil;
}

#pragma mark - Property

- (void)set_anchorPoint_x:(CGFloat)x y:(CGFloat)y
{
	self.layer.anchorPoint = CGPointMake(x, y);
}

- (void)set_positionType_type:(NSString *)type
{
    if ([type isEqualToString:@"px"]) {
        _positionType = SELayerPositionTypePX;
    }else if ([type isEqualToString:@"normalized"]){
        _positionType = SELayerPositionTypeNormalized;
    }
}

#pragma mark - Image

- (void)loadImage_path:(NSString *)path options:(NSDictionary *)options
{
	
}

- (void)clearImage
{
	
}

- (void)clear
{
	
}

#pragma mark - Appearence

- (void)bg_color:(NSDictionary *)color
{
	
}

- (void)border_width:(CGFloat)width color:(NSString *)color
{
	
}

- (void)shadow_options:(NSDictionary *)options
{
    // color, offset, opacity, radius,
}

#pragma mark - Animations

- (void)enqueuAnimationForKeyPath:(NSString *)keyPath toValue:(id)value duration:(NSTimeInterval)duration
{
    NSParameterAssert(keyPath != nil);
    NSParameterAssert(value != nil);
    NSParameterAssert(duration >= 0);
    if (duration == 0) {
        // durationが0ならばアニメーションはしない
        [self.layer setValue:value forKeyPath:keyPath];
        return;
    }
    // 対応するキーはちゃんとあるか？
    id val = [self.layer valueForKeyPath:keyPath];
    NSAssert(val, @"keyPathが間違ってる");
    // アニメーションを作成
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    // アニメーションの合成中は個別の間隔は無視
    if (!_animationBegan) {
        animation.duration = duration;
    }
    // 元に戻さない
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    if (_animationBegan) {
        // アニメーションの合成ならばキューに貯める
        NSArray *as = _animationGroup.animations;
        _animationGroup.animations = [as arrayByAddingObject:animation];
    }else{
        // 通常の実行
        [self addAnimation:animation forKey:keyPath];
    }
}

- (void)addAnimation:(CAAnimation*)animation forKey:(NSString *)key
{
    NSParameterAssert(animation != nil);
    NSParameterAssert(key != nil);
    // レイヤーへのアニメーションが被らないようにUUIDを付ける
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    NSString *uuid = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *animationKey = [NSString stringWithFormat:@"%@-%@",key,uuid];
#if TARGET_OS_IPHONE
    // UIView.layerだとこれを挟まないと正常に動作しないことがある
    [UIView beginAnimations:animationKey context:nil];
#endif
    [CATransaction begin];    
    // アニメーションを逐次実行するためにRunLoopでブロックする
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    CFDateRef distantFuture = (__bridge CFDateRef)[NSDate distantFuture];
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(NULL, CFDateGetAbsoluteTime(distantFuture), 0, 0, 0, NULL, NULL);
    CFRunLoopAddTimer(rl, timer, kCFRunLoopDefaultMode);
    [CATransaction setCompletionBlock:^{
        // 後片付け
        CFRunLoopStop(rl);
        CFRunLoopTimerInvalidate(timer);
        CFRelease(timer);
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
    NSAssert(duration > 0, @"durationが0以下");
    CAAnimationGroup *g = [CAAnimationGroup animation];
    g.duration = duration;
}

- (void)commitAnimation
{
    // Queueに貯めたアニメーションをグループ化して追加する
    NSAssert(_animationBegan, @"beginAnimationが呼ばれていない");
    NSAssert(_animationGroup.animations.count > 0, @"アニメーションが追加されていない");
    [self addAnimation:_animationGroup forKey:kGroupedAnimationKey];
    _animationBegan = NO;
    _animationGroup = nil;
}

- (void)position_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    CGPoint position = CGPointMake(x, y);
    NSValue *v = [NSValue se_valueWithPoint:position];
    [self enqueuAnimationForKeyPath:@"position" toValue:v duration:duration];
}

- (void)zPosition_z:(CGFloat)z duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"zPosition" toValue:@(z) duration:duration];
}

- (void)size_width:(CGSize)size duration:(NSTimeInterval)duration
{
    CGRect bounds = self.layer.bounds;
    bounds.size = size;
    NSValue *v = [NSValue se_valueWithRect:bounds];
	[self enqueuAnimationForKeyPath:@"bounds" toValue:v duration:duration];
}

- (void)show_duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"hidden" toValue:@(NO) duration:duration];
}

- (void)hide_duration:(NSTimeInterval)duration
{
	[self enqueuAnimationForKeyPath:@"hidden" toValue:@(YES) duration:duration];
}

- (void)toggle_duration:(NSTimeInterval)duration
{
    BOOL hidden = self.layer.hidden;
	[self enqueuAnimationForKeyPath:@"hidden" toValue:@(!hidden) duration:duration];
}

- (void)translate_x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z duration:(NSTimeInterval)duration
{
    CATransform3D trans = CATransform3DMakeTranslation(x, y, z);
	[self enqueuAnimationForKeyPath:@"transform.translate" toValue:[NSValue valueWithCATransform3D:trans] duration:duration];
}

- (void)scale_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
	[self enqueuAnimationForKeyPath:@"transform.scale" toValue:@(ratio) duration:duration];
}

- (void)rotate_degree:(CGFloat)degree duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"transform.rotation.z" toValue:@(degree) duration:duration];
}

- (void)opacity_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"opacity" toValue:@(ratio) duration:duration];
}


@end

