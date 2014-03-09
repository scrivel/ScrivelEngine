//
//  CAKeyframeAnimation+ScrivelEngine.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/09.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "CAKeyframeAnimation+ScrivelEngine.h"

@implementation CAKeyframeAnimation (ScrivelEngine)

+ (instancetype)se_keyFrameAnimationWithKeyPath:(NSString *)keyPath Duration:(CFTimeInterval)duration fps:(double)fps valueBlock:(id (^)(NSUInteger))valueBlock
{
    if (!valueBlock) {
        return nil;
    }
    // 実際のフレーム数
    NSUInteger frameCount = (NSUInteger)duration*fps;
    // keytimes
    NSMutableArray *keytimes = [NSMutableArray arrayWithCapacity:frameCount];
    // values
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:frameCount];
    // 総フレーム数に対して正規化されたkeytimeの値を割り振る
    double t;
    NSUInteger i;
    double add = (double)1/frameCount;
    for (i = 0, t = 0; t <= 1.0; t+= add, i++){
        [keytimes addObject:@(t)];
        [values addObject:valueBlock(i)];
    }
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    kfa.keyTimes = keytimes;
    kfa.values = values;
    kfa.duration = duration;
    return kfa;
}


@end
