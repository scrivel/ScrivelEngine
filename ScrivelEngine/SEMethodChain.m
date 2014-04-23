//
//  SEMethodChain.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethodChain.h"
#import "SEObject.h"
#import "SEMethod.h"
#import "ScrivelEngine.h"

@implementation SEMethodChain

- (instancetype)initWithTarget:(NSString *)target type:(SEMethodChainType)type
{
    self = [self init];
    _target = target;
    _type = type;    
    _methods = [NSMutableArray new];
    return self ?: nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_methods countByEnumeratingWithState:state objects:buffer count:len];
}

#pragma mark - Script Component

- (NSString *)elementName
{
    return @"methodChain";
}

@end
