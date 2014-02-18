
//
//  _SEConcretLayer.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEConcretLayer.h"

#define kMaxLayer 1000
static NSMutableArray *layers;

@implementation SEConcretLayer
{
    NSMutableArray *_animationQueue;
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

- (void)enqueuAnimationForKeyPath:(NSString *)keyPath toValue:(id)value duration:(NSTimeInterval)duration ordered:(BOOL)ordered
{
    // アニメーションを作成
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    id val = [self.layer valueForKeyPath:keyPath];
    NSParameterAssert(val);
    
    // 元に戻さない
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    // スタート
#if TARGET_OS_IPHONE
    // UIView.layerだとこれを挟まないと正常に動作しないことがある
    [UIView beginAnimations:nil context:nil];
#endif
    [CATransaction begin];
    if (ordered) {
        // アニメーションを逐次実行するためにrun roopでブロックする
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
    }
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    NSString *uuid = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    [self.layer addAnimation:animation forKey:[NSString stringWithFormat:@"%@-%@",animation.keyPath,uuid]];
    [CATransaction commit];
#if TARGET_OS_IPHONE
    [UIView commitAnimations];
#endif
    if (ordered) {
        CFRunLoopRun();
    }
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

#pragma mark - Image

- (void)setImage_path:(NSString *)path options:(NSDictionary *)options
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

- (void)position_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration
{
    CGPoint position = CGPointMake(x, y);
    [self enqueuAnimationForKeyPath:@"position" toValue:[NSValue valueWithCGPoint:position] duration:duration ordered:YES];
}

- (void)zPosition_z:(CGFloat)z duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"zPosition" toValue:@(z) duration:duration ordered:YES];
}

- (void)size_width:(CGSize)size duration:(NSTimeInterval)duration
{
    CGRect bounds = self.layer.bounds;
    bounds.size = size;
	[self enqueuAnimationForKeyPath:@"bounds" toValue:[NSValue valueWithCGRect:bounds] duration:duration ordered:YES];
}

- (void)show_duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"hidden" toValue:@(NO) duration:duration ordered:YES];
}

- (void)hide_duration:(NSTimeInterval)duration
{
	[self enqueuAnimationForKeyPath:@"hidden" toValue:@(YES) duration:duration ordered:YES];
}

- (void)toggle_duration:(NSTimeInterval)duration
{
    BOOL hidden = self.layer.hidden;
	[self enqueuAnimationForKeyPath:@"hidden" toValue:@(!hidden) duration:duration ordered:YES];
}

- (void)translate_x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z duration:(NSTimeInterval)duration
{
    CATransform3D trans = CATransform3DMakeTranslation(x, y, z);
	[self enqueuAnimationForKeyPath:@"transform.translate" toValue:[NSValue valueWithCATransform3D:trans] duration:duration ordered:YES];
}

- (void)scale_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
	[self enqueuAnimationForKeyPath:@"transform.scale" toValue:@(ratio) duration:duration ordered:YES];
}

- (void)rotate_degree:(CGFloat)degree duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"transform.rotation.z" toValue:@(degree) duration:duration ordered:YES];
}

- (void)opacity_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration
{
    [self enqueuAnimationForKeyPath:@"opacity" toValue:@(ratio) duration:duration ordered:YES];
}

- (void)animate_animations:(NSDictionary *)animations duration:(NSTimeInterval)duration
{
	// opacity, rotate, scale, translate, hidden, position, zPosition, size
}



@end

