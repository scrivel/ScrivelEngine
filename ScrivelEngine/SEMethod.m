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
    return [[self alloc] initWithName:kNameMethod type:SEScriptTypeMethodCall];
}

+ (instancetype)textMethod
{
    return [[self alloc] initWithName:kTextMethod type:SEScriptTypeMethodCall];
}

- (instancetype)initWithName:(NSString *)name type:(SEScriptType)type
{
    if (self = [super init] ) {
        _type = type;
        _name = name;
    }
    return self;
}

- (NSString *)description
{
    NSString *type = _type == SEScriptTypeAccessor ? @"Accessor" : @"MethodCall";
    return [NSString stringWithFormat:@"SEMethod \"%@\" type : \"%@\"",_name,type];
}

@end

