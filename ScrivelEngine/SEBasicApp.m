//
//  SEBasicApp.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicApp.h"

#define kPositionTypeKey @"positionType"
#define kSizeTypeKey @"sizeType"

@implementation SEBasicApp
{
    NSMutableDictionary *__keyValueStore;
    NSMutableDictionary *__enabledStore;
}

- (id)init
{
    self = [super init];
    __keyValueStore = [NSMutableDictionary new];
    __enabledStore = [NSMutableDictionary new];
    [self set_key:kPositionTypeKey value:@"norm"];
    [self set_key:kSizeTypeKey value:@"px"];
    return self ?: nil;
}

- (void)set_key:(NSString *)key value:(id)value
{
    if (key && value != nil && value != [NSNull null]) {
        [__keyValueStore setObject:value forKey:key];
    }
}

- (void)enable_key:(NSString *)key enable:(BOOL)enable
{
    if (key) {
        [__enabledStore setObject:@(enable) forKey:key];
    }
}

#pragma mark - Accessor

- (SEPositionType)positionType
{
    NSString *t = [__keyValueStore objectForKey:kPositionTypeKey];
    if ([t isEqualToString:@"norm"]) {
        return SEPositionTypeNormalized;
    }else if ([t isEqualToString:@"px"]){
        return SEPositionTypePX;
    }
    return SEPositionTypeNormalized;
}

- (SESizeType)sizeType
{
    NSString *t = [__keyValueStore objectForKey:kSizeTypeKey];
    if ([t isEqualToString:@"norm"]) {
        return SESizeTypeNormalized;
    }else if ([t isEqualToString:@"px"]){
        return SESizeTypePX;
    }
    return SESizeTypePX;
}

@end
