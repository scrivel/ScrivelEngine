//
//  Queue.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/19.
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
    [_concret insertObject:obj atIndex:0];
}

- (id)dequeue
{
    id obj = [_concret lastObject];
    [_concret removeLastObject];
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

@end
