//
//  NSString+Dequoted.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/20.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "NSString+Dequoted.h"

@implementation NSString(Dequoted)

- (NSString*)dequotedString
{
    char f = [self characterAtIndex:0];
    char l = [self characterAtIndex:self.length-1];
    if ((f == '"' && l == '"') || (f == '\'' && l == '\'')){
        return [self substringWithRange:NSMakeRange(1, self.length-2)];
    }
    return self;
}

@end