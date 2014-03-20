//
//  SEHtml.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/20.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEHTML.h"

@implementation SEHTML

- (instancetype)initWithTagName:(NSString *)tagName
{
    self = [super init];
    if ([tagName isEqualToString:@"p"]){
        _htmlTagType = SEHTMLTagTypeParagraph;
    }else if ([tagName isEqualToString:@"b"]) {
        _htmlTagType = SEHTMLTagTypeBold;
    }else if ([tagName isEqualToString:@"i"]){
        _htmlTagType = SEHTMLTagTypeItalic;
    }else if ([tagName isEqualToString:@"u"]){
        _htmlTagType = SEHTMLTagTypeUnderline;
    }
    return self ?: nil;
}

@end
