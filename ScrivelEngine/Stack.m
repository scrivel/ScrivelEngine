//
//  Stack.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "Stack.h"

@implementation Stack
{
    NSMutableArray *ma;
}
- (id)init
{
    self = [super init];
    if (self) {
        ma = [NSMutableArray new];
    }
    return self;
}

- (id)pop
{
    id obj = [ma lastObject];
    [ma removeLastObject];
    return obj;
}

- (void)push:(id)obj
{
    [ma addObject:obj];
}

- (NSUInteger)count
{
    return ma.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [ma countByEnumeratingWithState:state objects:buffer count:len];
}

@end
