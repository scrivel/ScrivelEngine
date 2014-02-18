
//
//  _SEConcretLayer.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEConcretObject.h"
#import "SELayer.h"

typedef enum{
    SELayerPositionTypePX,
    SELayerPositionTypeNormalized
}SELayerPositionType;

@interface SEConcretLayer : SEConcretObject <SELayer>

@property (nonatomic) NSUInteger index;
@property (nonatomic) CALayer *layer;
@property (nonatomic) SELayerPositionType positionType;

- (void)enqueuAnimationForKeyPath:(NSString*)keyPath toValue:(id)value duration:(NSTimeInterval)duration ordered:(BOOL)ordered;

@end

