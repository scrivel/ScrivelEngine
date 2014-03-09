//
//  CAKeyframeAnimation+ScrivelEngine.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/09.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAKeyframeAnimation (ScrivelEngine)

+ (instancetype)se_keyFrameAnimationWithKeyPath:(NSString*)keyPath
                                       Duration:(CFTimeInterval)duration
                                            fps:(double)fps
                                     valueBlock:(id (^)(NSUInteger frameNumber))valueBlock;

@end
