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

- (NSString *)description
{
    NSString *type = _type == SEMethodTypeProperty ? @"Accessor" : @"MethodCall";
    return [NSString stringWithFormat:@"SEMethod \"%@\" type : \"%@\"",_name,type];
}

- (id)callWithTarget:(id)target
{
    return nil;
}

@end

