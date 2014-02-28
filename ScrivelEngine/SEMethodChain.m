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

- (instancetype)initWithTargetClass:(NSString *)targetClass
{
    self = [self init];
    _targetClass = targetClass;
    _methods = [NSMutableArray new];    
    return self ?: nil;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_methods countByEnumeratingWithState:state objects:buffer count:len];
}

@end
