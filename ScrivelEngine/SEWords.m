//
//  SEWords.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEWords.h"

@implementation SEWords

- (instancetype)initWithCharacter:(NSString *)character arguments:(NSArray *)arguments
{
    self = [self init];
    _character = character;
    _arguments = arguments;
    return self ?:nil;
}

- (NSString *)text
{
    return [_arguments objectAtIndex:0];
}

- (NSDictionary *)options
{
    return [_arguments objectAtIndex:1];
}

#pragma mark - 

- (NSString *)elementName
{
    return @"words";
}

@end
