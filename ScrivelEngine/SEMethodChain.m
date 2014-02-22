//
//  SEMethodChain.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethodChain.h"
#import "SEObject.h"
#import "SEGlobalObject.h"
#import "SEMethod.h"
#import "ScrivelEngine.h"

@implementation SEMethodChain

- (instancetype)initWithLineNumber:(NSUInteger)lineNumber
{
    self = [self init];
    _methods = [NSMutableArray new];
    return self ?: nil;
}

- (void)enqueueMethod:(SEMethod *)method
{
    [_methods addObject:method];
}

- (SEMethod *)dequeueMethod
{
    if (_methods.count > 0) {
        SEMethod *m = [_methods objectAtIndex:0];
        [_methods removeObjectAtIndex:0];
        return m;
    }
    return nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_methods countByEnumeratingWithState:state objects:buffer count:len];
}

@end
