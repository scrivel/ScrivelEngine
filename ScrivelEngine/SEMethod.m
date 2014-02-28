//
//  SEScript.m
//  PetiteCouturiere
//
//  Created by keroxp on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethod.h"
#import <ParseKit/ParseKit.h>
#import "ScrivelEngine.h"
#import "NSNumber+CGFloat.h"

static inline BOOL VALID(id val){
    return (val != nil && val != [NSNull null]);
}

@implementation SEMethod

- (instancetype)initWithName:(NSString *)name type:(SEMethodType)type lineNumer:(NSUInteger)lineNumber
{
    if (self = [super init] ) {
        _type = type;
        _name = name;
        _lineNumber = lineNumber;
    }
    return self;
}

#pragma mark - Args

- (id)argAtIndex:(NSUInteger)index
{
    return (index < self.arguments.count) ? self.arguments[index] : nil;
}

- (NSInteger)integerArgAtIndex:(NSUInteger)index
{
    id val = [self argAtIndex:index];
    return VALID(val) ? [val integerValue] : SENilInteger;
}

- (NSUInteger)unsignedIntegerArtAtIndex:(NSUInteger)index
{
    id val = [self argAtIndex:index];
    return VALID(val) ? [val unsignedIntegerValue] : SENilUInteger;
}

- (double)doubleArgAtIndex:(NSUInteger)index
{
    id val = [self argAtIndex:index];
    return VALID(val) ? [val doubleValue] : DBL_MIN;
}

- (CGFloat)CGFloatArgAtIndex:(NSUInteger)index
{
    id val = [self argAtIndex:index];
    return VALID(val) ? [val CGFloatValue] : SENilCGFloat;
}

- (BOOL)boolArgAtIndex:(NSUInteger)index
{
    id val = [self argAtIndex:index];
    return VALID(val) ? [val boolValue] : NO;
}

- (NSString *)description
{
    NSString *type = _type == SEMethodTypeProperty ? @"Accessor" : @"MethodCall";
    return [NSString stringWithFormat:@"SEMethod \"%@\" type : \"%@\"",_name,type];
}

@end

