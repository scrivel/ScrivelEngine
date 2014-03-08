//
//  Queue.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "Queue.h"

@implementation Queue
{
    NSMutableArray *_concret;
}

- (id)init
{
    self = [super init];
    _concret = [NSMutableArray new];
    return self ?: nil;
}

- (void)enqueue:(id)obj
{
    [self enqueue:obj prior:NO];
}

- (void)enqueue:(id)obj prior:(BOOL)prior
{
    if (prior) {
        [_concret insertObject:obj atIndex:0];
    }else{
        [_concret addObject:obj];
    }
}

- (void)enqueueObjects:(NSArray *)objcts
{
    [self enqueueObjects:objcts prior:NO];
}

- (void)enqueueObjects:(NSArray *)objcts prior:(BOOL)prior
{
    if (prior) {
        NSIndexSet *is = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, objcts.count)];
        [_concret insertObjects:objcts atIndexes:is];
    }else{
        [_concret addObjectsFromArray:objcts];
    }
}

- (id)dequeue
{
    id obj = [_concret firstObject];
    if (_concret.count > 0) {
        [_concret removeObjectAtIndex:0];
    }
    return obj;
}

- (void)clear
{
    [_concret removeAllObjects];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_concret countByEnumeratingWithState:state objects:buffer count:len];
}

- (NSUInteger)count
{
    return _concret.count;
}

- (id)head
{
    return [_concret firstObject];
}

- (id)tail
{
    return [_concret lastObject];
}

@end
