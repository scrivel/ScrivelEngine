//
//  SETag.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/20.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SETag.h"

@implementation SETag

- (instancetype)initWithTagName:(NSString *)tagName
{
    self = [self init];
    if ([tagName isEqualToString:@"l"]) {
        _tagType = SETagTypeWaitInline;
    }else if ([tagName isEqualToString:@"r"]){
        _tagType = SETagTypeLineBreak;
    }else if ([tagName isEqualToString:@"p"]){
        _tagType = SETagTypeWaitBlock;
    }
    return self ?: nil;
}

@end
