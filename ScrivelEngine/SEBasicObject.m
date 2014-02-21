
//
//  _SEConcretObject.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicObject.h"

@implementation SEBasicObject

- (instancetype)initWithOpts:(NSDictionary *)options
{
    self = [self init];
    return self ?: nil;
}

#pragma mark - SEObject

+ (instancetype)new_options:(NSDictionary *)options
{
	return [[self alloc] initWithOpts:options];
}

+ (id)callStatic_method:(SEMethod *)method engine:(ScrivelEngine *)engine
{
    return nil;
}

- (id)callInstance_method:(SEMethod *)method engine:(ScrivelEngine *)engine
{
	return nil;
}

- (id)wait_duration:(NSTimeInterval)duration
{
	return nil;
}



@end

