
//
//  _SEConcretLayer.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEBasicObject.h"
#import "SELayer.h"
#import <objc/runtime.h>

typedef enum{
    SELayerPositionTypePX,
    SELayerPositionTypeNormalized
}SELayerPositionType;

@interface SEBasicLayer : SEBasicObject <SELayer>

+ (NSDictionary*)layers;

@property (nonatomic) unsigned int index;
@property (nonatomic) CALayer *layer;
@property (nonatomic) SELayerPositionType positionType;

- (void)enqueuAnimationForKeyPath:(NSString*)keyPath
                          toValue:(id)value
                         duration:(NSTimeInterval)duration
                       completion:(void(^)())completion;
- (void)addAnimation:(CAAnimation*)animation
              forKey:(NSString *)key
          completion:(void(^)())completion;
- (instancetype)initWithOpts:(NSDictionary *)options;

@end

