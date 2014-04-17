
//
//  SEbasicLayer.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEBasicObject.h"
#import "SELayer.h"

#define ACTUAL_DURATION(d) [self.holder.engine convertDuration:ROUND_CGFLOAT(d)]
#define VIEW_SIZE self.engine.rootView.bounds.size

@interface SEBasicLayerClass : SEBasicObjectClass <SELayerClass>

@property (nonatomic, readonly) NSDictionary *layers;
@property (nonatomic) NSUInteger activeAnimationCount;
@property (nonatomic) NSDictionary *definedAnimations;

@end

@interface SEBasicLayer : SEBasicObject <SELayerInstance>

@property (nonatomic) id<NSCopying> key;
@property (nonatomic) unsigned int index;
@property (nonatomic) CALayer *layer;
@property (nonatomic, readonly) BOOL added;
@property (nonatomic, readonly) BOOL isChaining;
@property (nonatomic, readonly) BOOL isRepeatingForever;

- (void)didMoveToSuperLayer:(CALayer*)layer;

@end

