//
//  SECALayer.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/03/12.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ScrivelEngine.h"

@interface SECALayer : NSProxy

+ (instancetype)layerWithContentLayer:(CALayer*)contentLayer;

@property (nonatomic, readonly) CALayer *foregroundLayer;
@property (nonatomic) CALayer *contentLayer;
@property (nonatomic, readonly) CALayer *backgroundLayer;
@property (nonatomic) SEEdgeInsets padding;


@end

