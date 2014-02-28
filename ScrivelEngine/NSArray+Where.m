//
//  NSArray+Where.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/21.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "NSArray+Where.h"
#import <objc/message.h>

@implementation NSArray (Where)

- (NSArray *)whereUsingSelector:(SEL)selector value:(id)value
{
    return [self whereForKeyPath:nil comparingSelector:selector value:value];
}

- (NSArray *)whereForKeyPath:(NSString *)keyPath comparingSelector:(SEL)selector value:(id)value
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        id target = keyPath ? [obj valueForKeyPath:keyPath] : obj;
        if ([target respondsToSelector:selector]){
            if(objc_msgSend(target, selector, value)) {
                [array addObject:target];
            }
        }
    }
    return [NSArray arrayWithArray:array];
}

@end