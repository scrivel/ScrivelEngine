//
//  SEParentLayer.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/06.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SELayerView.h"
#import "SEBasicLayer.h"

@implementation SELayerView
{
    NSMutableArray *__children;
}
- (id)init
{
    self = [super init];
    __children = [NSMutableArray new];
#if SE_TARGET_OS_MAC
    self.wantsLayer = YES;
#endif
    return self ?: nil;
}

- (void)addChildLayer:(SEBasicLayer *)child
{
    [self insertChildLayer:child atIndex:(unsigned int)__children.count];
}

- (void)insertChildLayer:(SEBasicLayer *)child atIndex:(unsigned int)index
{
    [child.layer removeFromSuperlayer];
    [self.layer insertSublayer:child.layer atIndex:index];
    [__children insertObject:child atIndex:index];
}

- (void)removeChildLayer:(SEBasicLayer *)child
{
    [child.layer removeFromSuperlayer];
    [__children removeObject:child];
}

- (void)removeAllChildLayers
{
    for (SEBasicLayer *layer in __children.copy) {
        [self removeChildLayer:layer];
    }
}

@end
