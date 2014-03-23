//
//  SEElement.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"

@implementation SEElement

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"rangeOfLines": @"range_of_lines",
             @"elementName" : @"element_name"};
}

+ (NSValueTransformer*)rangeOfLinesJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSDictionary*di) {
        NSRange range;
        range.location = [di[@"location"] unsignedIntegerValue];
        range.length = [di[@"length"] unsignedIntegerValue];
        return [NSValue valueWithRange:range];
    } reverseBlock:^id(NSValue *val) {
        NSRange range = [val rangeValue];
        return @{@"location": @(range.location),
                 @"length" : @(range.length)};
    }];
}

- (NSString *)elementName
{
    return @"element";
}

@end
