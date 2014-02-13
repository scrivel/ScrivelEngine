//
//  SEScript.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethod.h"
#import <ParseKit/ParseKit.h>
#import "PKToken+ScrivelEngine.h"

@implementation SEMethod

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

