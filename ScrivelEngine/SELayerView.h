//
//  SEParentLayer.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/06.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEBasicLayer;
@interface SELayerView : SEView

@property (nonatomic, readonly) NSArray *children;

- (void)addChildLayer:(SEBasicLayer*)child;
- (void)insertChildLayer:(SEBasicLayer*)child atIndex:(unsigned int)index;
- (void)removeChildLayer:(SEBasicLayer*)child;
- (void)removeAllChildLayers;

@end
