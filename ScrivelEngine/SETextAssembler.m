//
//  SETextAssembler.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/20.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SETextAssembler.h"
#import <ParseKit/ParseKit.h>
#import "Stack.h"
#import "NSString+Dequoted.h"
#import "SETag.h"
#import "SEHTML.h"

@implementation SETextAssembler
{
    Stack *_textStack;
    Stack *_stringStack;
    Stack *_tagStack;
    Stack *_htmlStack;
    Stack *_attributeStack;
    Stack *_identifierStack;
}

- (id)init
{
    self = [super init];
    _textStack = [Stack new];
    _stringStack = [Stack new];
    _tagStack = [Stack new];
    _htmlStack = [Stack new];
    _attributeStack = [Stack new];
    _identifierStack = [Stack new];
    return self ?: nil;
}

- (void)parser:(PKParser *)parser didMatchText:(PKAssembly *)assembly
{
    id text;
    if((text = [_tagStack pop])){
        [_textStack push:text];
    }else if ((text = [_htmlStack pop])){
        [_textStack push:text];
    }else if ((text = [_stringStack pop])){
        [_textStack push:text];
    }
}

- (void)parser:(PKParser *)parser didMatchHtml:(PKAssembly *)assembly
{
    SEHTML *html = [SEHTML new];
    NSString *tagName = [_identifierStack pop];
    [_identifierStack pop];
    NSMutableDictionary *attrs = [NSMutableDictionary new];
    NSDictionary *attr;
    while ((attr = [_attributeStack pop]) != nil) {
        [attrs setObject:attr.allValues[0] forKey:attr.allKeys[0]];
    }
    html.attributes = attrs;
    id content = [_textStack pop];
    html.content = content;
    [_htmlStack push:html];
}

- (void)parser:(PKParser *)parser didMatchAttr:(PKAssembly *)assembly
{
    NSString *key = [_identifierStack pop];
    PKToken *tok = [assembly pop];
    NSString *value = [tok.stringValue dequotedString];
    [_attributeStack push:@{key: value}];
}

- (void)parser:(PKParser *)parser didMatchTag:(PKAssembly *)assembly
{
    NSString *tagName = [_identifierStack pop];
    SETag *tag = [[SETag alloc] initWithTagName:tagName];
    [_tagStack push:tag];
}

- (void)parser:(PKParser *)parser didMatchString:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    [_stringStack push:tok.stringValue];
}

- (void)parser:(PKParser *)parser didMatchIdentifier:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    [_identifierStack push:tok.stringValue];
}

@end

