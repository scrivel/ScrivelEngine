//
//  SEScript.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethod.h"
#import <ParseKit/ParseKit.h>

#define kNameMethod @"name"
#define kTextMethod @"text"

@implementation SEMethod

+ (instancetype)nameMethod
{
    return [[self alloc] initWithName:kNameMethod type:SEMethodTypeCall];
}

+ (instancetype)textMethod
{
    return [[self alloc] initWithName:kTextMethod type:SEMethodTypeCall];
}

- (instancetype)initWithName:(NSString *)name type:(SEMethodType)type
{
    if (self = [super init] ) {
        _type = type;
        _name = name;
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
    return [[self argAtIndex:index] integerValue];
}

- (double)doubleArgAtIndex:(NSUInteger)index
{
    return [[self argAtIndex:index] doubleValue];
}

- (NSString *)description
{
    NSString *type = _type == SEMethodTypeProperty ? @"Accessor" : @"MethodCall";
    return [NSString stringWithFormat:@"SEMethod \"%@\" type : \"%@\"",_name,type];
}

@end

