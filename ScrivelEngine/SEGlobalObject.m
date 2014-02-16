//
//  SEGlobalObject.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEGlobalObject.h"
#import "SEMethod.h"

static SEGlobalObject *shared;

@implementation SEGlobalObject

+ (instancetype)sharedObject
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

@end
