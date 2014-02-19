//
//  SEScriptAssembler.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScriptAssembler.h"
#import "SEMethodChain.h"
#import "SEMethod.h"
#import "SEScript.h"
#import "Stack.h"

@interface SEScriptAssembler ()

// メソッド
- (void)pushIdentifier:(NSString*)identifier;
- (void)pushKey:(NSString*)key;
- (void)pushKeyValue:(NSArray*)keyValue;
- (void)pushValue:(id)value;
- (void)pushArray:(NSArray*)array;
- (void)pushObject:(NSDictionary*)object;
- (void)pushArguments:(NSArray*)arguments;
- (void)pushMethod:(SEMethod*)method;
- (void)pushMethodChain:(SEMethodChain*)methodChain;

- (NSString*)popIdentifier;
- (NSString*)popKey;
- (NSArray*)popKeyValue;
- (id)popValue;
- (NSArray*)popArray;
- (NSDictionary*)popObject;
- (NSArray*)popArguments;
- (SEMethod*)popMethod;
- (SEMethodChain*)popMethodChain;

// セリフ
- (void)pushName:(NSString*)name;
- (void)pushText:(NSString*)text;
- (NSString*)popName;
- (NSString*)popText;

- (void)pushElement:(SEElement*)element;
- (SEElement*)popElement;

@end

@implementation SEScriptAssembler
{
    SEScript *_script;

    Stack *_elementStack;
    Stack *_methodChainStack;
    Stack *_methodStack;
    Stack *_argumentsStack;
    Stack *_objectStack;
    Stack *_arrayStack;
    Stack *_valueStack;
    Stack *_keyValueStack;
    Stack *_keyStack;
    Stack *_identifierStack;
    Stack *_nameStack;
    Stack *_textStack;
}


- (id)init
{
    self = [super init];
    _script = [SEScript new];
    
    _elementStack = [Stack new];
    _methodChainStack = [Stack new];
    _methodStack = [Stack new];
    _argumentsStack = [Stack new];
    _objectStack = [Stack new];
    _argumentsStack = [Stack new];
    _valueStack = [Stack new];
    _keyValueStack = [Stack new];
    _keyStack = [Stack new];
    _identifierStack = [Stack new];
    _nameStack = [Stack new];
    _textStack = [Stack new];
    
    return self ?:nil;
}

- (SEScript *)assemble
{
    return _script;
}

#pragma mark - Assembler


- (void)parser:(PKParser *)parser didMatchScript:(PKAssembly *)assembly{
    SEElement *element = nil;
    while ((element = [self popElement]) != nil) {
        [_script.elements insertObject:element atIndex:0];
    }
}

- (void)parser:(PKParser *)parser didMatchElement:(PKAssembly *)assembly{
    // メソッドチェーンかセリフをpush
    id pop = [self popMethodChain];
    [self pushElement:pop];
}

- (void)parser:(PKParser *)parser didMatchMethodChain:(PKAssembly *)assembly
{
    SEMethodChain *chain = [[SEMethodChain alloc] initWithLineNumber:parser.tokenizer.lineNumber];
    SEMethod *m = nil;
    while ((m = [self popMethod]) != nil) {
        [chain.methods insertObject:m atIndex:0];
    }
    [self pushMethodChain:chain];
}

- (void)parser:(PKParser *)parser didMatchMethod:(PKAssembly *)assembly
{
    NSArray *args = [self popArguments];
    NSString *identifier = [self popIdentifier];
    SEMethod *method = nil;
    if (args) {
        method = [[SEMethod alloc] initWithName:identifier type:SEMethodTypeCall];
        [method setArguments:args];
    }else{
        method = [[SEMethod alloc] initWithName:identifier type:SEMethodTypeProperty];
    }
    [self pushMethod:method];
}

- (void)parser:(PKParser *)parser didMatchArguments:(PKAssembly *)assembly
{
    id value = nil;
    NSMutableArray *ma = [NSMutableArray new];
    while ((value = [self popValue]) != nil) {
        [ma addObject:value];
    }
    if (ma.count > 0) {
        [self pushArguments:[NSArray arrayWithArray:ma]];
    }else{
        [self pushArguments:@[]];
    }
}

- (void)parser:(PKParser *)parser didMatchValue:(PKAssembly *)assembly
{
    id obj = [self popObject];
    if (obj) {
        [self pushValue:(NSDictionary*)obj];
    }
    obj = [self popArray];
    if (obj) {
        [self pushValue:(NSArray*)obj];
    }
    PKToken *tok = [assembly pop];
    if (tok.tokenType == PKTokenTypeQuotedString
        || tok.tokenType == PKTokenTypeNumber) {
        [self pushValue:tok.value];
    }
}

- (void)parser:(PKParser *)parser didMatchArray:(PKAssembly *)assembly
{
    NSMutableArray *ma = [NSMutableArray new];
    id value = nil;
    while ((value = [self popValue]) != nil) {
        [ma addObject:value];
    }
    [self pushArray:[NSArray arrayWithArray:ma]];
}

- (void)parser:(PKParser *)parser didMatchObject:(PKAssembly *)assembly
{
    NSMutableDictionary *di = [NSMutableDictionary new];
    NSArray *keyValue = nil;
    while ((keyValue = [self popKeyValue]) != nil   ) {
        NSString *key = keyValue[0];
        id obj = keyValue[1];
        [di setObject:obj forKey:key];
    }
    [self pushObject:[NSDictionary dictionaryWithDictionary:di]];
}

- (void)parser:(PKParser *)parser didMatchKeyValue:(PKAssembly *)assembly
{
    NSString *key = [self popKey];
    id value = [self popValue];
    NSArray *keyValue = @[key,value];
    [self pushKeyValue:keyValue];
}

- (void)parser:(PKParser *)parser didMatchKey:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    if (tok.tokenType == PKTokenTypeQuotedString
        || tok.tokenType == PKTokenTypeWord) {
        [self pushKey:tok.stringValue];
    }
}

- (void)parser:(PKParser *)parser didMatchIdentifier:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    [self pushIdentifier:tok.stringValue];
}

#pragma mark - Words

- (void)parser:(PKParser *)parser didMatchWords:(PKAssembly *)assembly
{
    // セリフは実際はグローバルコンテクストへのメソッドコール
    NSString *name = [self popName];
    NSString *text = [self popText];
    SEMethodChain *chain = [[SEMethodChain alloc] initWithLineNumber:parser.tokenizer.lineNumber];
    if (name) {
        SEMethod *name_m = [SEMethod nameMethod];
        [name_m setArguments:@[name]];
        [chain.methods addObject:name_m];
    }
    SEMethod *text_m = [SEMethod textMethod];
    [text_m setArguments:@[text]];
    [chain.methods addObject:text_m];
    [self pushMethodChain:chain];
}

- (void)parser:(PKParser *)parser didMatchName:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    [self pushName:tok.stringValue];
}

- (void)parser:(PKParser *)parser didMatchText:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    [self pushText:tok.stringValue];
}

#pragma mark - Stack

// メソッド
- (void)pushIdentifier:(NSString*)identifier
{
    [_identifierStack push:identifier];
}
- (void)pushKey:(NSString*)key
{
    [_keyStack push:key];
}
- (void)pushKeyValue:(NSArray*)keyValue
{
    [_keyValueStack push:keyValue];
}
- (void)pushValue:(id)value
{
    [_valueStack push:value];
}
- (void)pushArray:(NSArray*)array
{
    [_arrayStack push:array];
}
- (void)pushObject:(NSDictionary*)object
{
    [_objectStack push:object];
}
- (void)pushArguments:(NSArray*)arguments
{
    [_argumentsStack push:arguments];
}
- (void)pushMethod:(SEMethod*)method
{
    [_methodStack push:method];
}
- (void)pushMethodChain:(SEMethodChain*)methodChain
{
    [_methodChainStack push:methodChain];
}

- (NSString*)popIdentifier
{
    return [_identifierStack pop];
}
- (NSString*)popKey
{
    return [_keyStack pop];
}
- (NSArray*)popKeyValue
{
    return [_keyValueStack pop];
}
- (id)popValue
{
    return [_valueStack pop];
}
- (NSArray*)popArray
{
    return [_arrayStack pop];
}
- (NSDictionary*)popObject
{
    return [_objectStack pop];
}
- (NSArray*)popArguments
{
    return [_argumentsStack pop];
}
- (SEMethod*)popMethod
{
    return [_methodStack pop];
}
- (SEMethodChain*)popMethodChain
{
    return [_methodChainStack pop];
}

// セリフ
- (void)pushName:(NSString*)name
{
    [_nameStack push:name];
}
- (void)pushText:(NSString*)text
{
    [_textStack push:text];
}
- (NSString*)popName
{
    return [_nameStack pop];
}
- (NSString*)popText
{
    return [_textStack pop];
}

- (void)pushElement:(SEElement*)element
{
    [_elementStack push:element];
}
- (SEElement*)popElement
{
    return [_elementStack pop];
}


@end
