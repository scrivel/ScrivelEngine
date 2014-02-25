
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

@interface SEBasicLayerClass : SEBasicObjectClass <SELayerClass>

@property (nonatomic, readonly) NSDictionary *layers;

@end

@interface SEBasicLayer : SEBasicObject <SELayerInstance>

@property (nonatomic) unsigned int index;
@property (nonatomic) CALayer *layer;

- (void)enqueuAnimationForKeyPath:(NSString*)keyPath
                          toValue:(id)value
                         duration:(NSTimeInterval)duration
                       completion:(void(^)())completion;
- (void)addAnimation:(CAAnimation*)animation
              forKey:(NSString *)key
          completion:(void(^)())completion;

@end

