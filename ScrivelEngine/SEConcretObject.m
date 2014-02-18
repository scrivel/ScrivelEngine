
//
//  _SEConcretObject.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEConcretObject.h"

@implementation SEConcretObject

- (instancetype)initWithOpts:(NSDictionary *)options
{
    self = [self init];
    return self ?: nil;
}

#pragma mark - SEObject

+ (instancetype)new_opts:(NSDictionary *)opts
{
	return [[self alloc] initWithOpts:opts];
}

+ (id)callStatic_method:(SEMethod *)method
{
    return nil;
}

- (id)callInstance_method:(SEMethod *)method
{
	return nil;
}

- (id)wait_duration:(NSTimeInterval)duration
{
	return nil;
}



@end

