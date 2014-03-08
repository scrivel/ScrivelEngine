//
//  Queue.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject
<NSFastEnumeration>

- (id)dequeue;
- (void)enqueue:(id)obj;
- (void)enqueueObjects:(NSArray*)objcts;
- (void)enqueue:(id)obj prior:(BOOL)prior;
- (void)enqueueObjects:(NSArray*)objcts prior:(BOOL)prior;
- (void)clear;

- (NSUInteger)count;
- (id)head;
- (id)tail;

@end
