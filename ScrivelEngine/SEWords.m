//
//  SEWords.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEWords.h"

@implementation SEWords

- (instancetype)initWithName:(NSString *)name text:(NSString *)text
{
    self = [self init];
    _name = name;
    _text = text;
    return self ?:nil;
}

@end
