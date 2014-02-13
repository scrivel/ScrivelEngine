//
//  SEObject.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEObject.h"
#import "SEGlobalObject.h"

@implementation SEObject

+ (BOOL)instancesRespondToMethod:(SEMethod *)method
{
    return YES;
}

+ (instancetype)staticObjectNamed:(NSString *)name
{
    if ([name isEqualToString:@"global"]) {
        return [SEGlobalObject new];
    }else if ([name isEqualToString:@"invalid"]){
        return nil;
    }
    return [self new];
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    _name = name;
    return self ?:nil;
}

- (id)invokeMethod:(SEMethod *)method
{
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"SEObject \"%@\"",_name];
}

@end
