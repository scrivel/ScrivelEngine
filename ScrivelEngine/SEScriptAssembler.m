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
#import "NSArray+Where.h"

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

- (void)pushElement:(id)element;
- (id)popElement;

@end

static PKToken *commaToken;
static PKToken *colonToken;
static PKToken *openBracketToken;
static PKToken *openCurlyToken;

@implementation SEScriptAssembler
{
    SEScript *_script;

    Stack *_elementStack;
    Stack *_methodChainStack;
    Stack *_methodStack;
    Stack *_argumentsStack;
    Stack *_objectStack;
    NSUInteger *_objectStackLength;
    Stack *_arrayStack;
    NSUInteger *_arrayStackLength;
    Stack *_valueStack;
    Stack *_keyValueStack;
    Stack *_keyStack;
    Stack *_identifierStack;
    Stack *_nameStack;
    Stack *_textStack;
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        commaToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"," floatValue:0];
        colonToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@":" floatValue:0];
        openBracketToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"[" floatValue:0];
        openCurlyToken = [PKToken tokenWithTokenType:PKTokenTypeSymbol stringValue:@"{" floatValue:0];
    });
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
    _arrayStack = [Stack new];
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
    id element = nil;
    while ((element = [self popElement]) != nil) {
        [_script.elements insertObject:element atIndex:0];
    }
}

- (void)parser:(PKParser *)parser didMatchElement:(PKAssembly *)assembly{
    // メソッドチェーンがあればpush
    id pop = [self popMethodChain];
    if (pop) {
        [self pushElement:pop];
    }
    // json形式のvalueならpush
    id val = [self popValue];
    if (val) {
        [self pushElement:val];
    }
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
        return;
    }
    obj = [self popArray];
    if (obj) {
        [self pushValue:(NSArray*)obj];
        return;
    }
    PKToken *tok = [assembly pop];
    if (tok.tokenType == PKTokenTypeQuotedString){
        // quoteを外す
        NSString *s = [tok.stringValue substringWithRange:NSMakeRange(1, tok.stringValue.length-2)];
        [self pushValue:s];
    }else if (tok.tokenType == PKTokenTypeNumber) {
        // NSNumber
        NSNumber *num = tok.value;
        [self pushValue:num];
    }else if (tok.tokenType == PKTokenTypeWord){
        if (tok.tokenKind == SESCRIPTPARSER_TOKEN_KIND_FALSE) {
            [self pushValue:@NO];
        }else if (tok.tokenKind == SESCRIPTPARSER_TOKEN_KIND_TRUE){
            [self pushValue:@YES];
        }else if (tok.tokenKind == SESCRIPTPARSER_TOKEN_KIND_NULL){
            [self pushValue:[NSNull null]];
        }
    }
}

- (void)parser:(PKParser *)parser didMatchArray:(PKAssembly *)assembly
{
    NSMutableArray *ma = [NSMutableArray new];
    id value = nil;
    // 直前の'['より上のvalue導出を数える
//    NSLog(@"%@",assembly.stack);
    NSUInteger vallen = [[[assembly objectsAbove:openBracketToken] whereUsingSelector:@selector(isEqual:) value:commaToken] count]; //  -> ,+ ']'
//    NSLog(@"%@",a);
//    NSLog(@"%@",assembly.stack);
    for (NSUInteger i = 0; i < vallen + 1 ; i++) {
        value = [self popValue];
        [ma insertObject:value atIndex:0];
    }
    [assembly pop];
    [self pushArray:[NSArray arrayWithArray:ma]];
}

- (void)parser:(PKParser *)parser didMatchObject:(PKAssembly *)assembly
{
    NSMutableDictionary *di = [NSMutableDictionary new];
    NSArray *keyValue = nil;
    // 直前の'{'よりも上のvalue導出を数える
//    NSLog(@"%@",assembly.stack);
    NSUInteger vallen = [[[assembly objectsAbove:openCurlyToken] whereUsingSelector:@selector(isEqual:) value:colonToken] count];
//    NSLog(@"%@",o);
//    NSLog(@"%@",assembly.stack);
    for (int i = 0; i < vallen; i++) {
        keyValue = [self popKeyValue];
        NSString *key = keyValue[0];
        id obj = keyValue[1];
        [di setObject:obj forKey:key];
    }
    [assembly pop];
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

- (void)pushElement:(id)element
{
    [_elementStack push:element];
}
- (id)popElement
{
    return [_elementStack pop];
}


@end
