//
//  SEScriptAssembler.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScriptAssembler.h"
#import "SEMethodChain.h"
#import "SEWords.h"
#import "SEMethod.h"
#import "SEScript.h"
#import "Stack.h"
#import "NSArray+Where.h"
#import "NSString+Dequoted.h"

@interface SEScriptAssembler ()
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
    Stack *_wordsStack;
    Stack *_characterStack;
    Stack *_nameStack;
    Stack *_methodStack;
    Stack *_argumentsStack;
    Stack *_objectStack;
    NSUInteger *_objectStackLength;
    Stack *_arrayStack;
    NSUInteger *_arrayStackLength;
    Stack *_valueStack;
    Stack *_keyValueStack;
    Stack *_objectKeyStack;
    Stack *_identifierStack;
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
    _wordsStack = [Stack new];
    _characterStack = [Stack new];
    _nameStack = [Stack new];
    _methodStack = [Stack new];
    _argumentsStack = [Stack new];
    _objectStack = [Stack new];
    _arrayStack = [Stack new];
    _argumentsStack = [Stack new];
    _valueStack = [Stack new];
    _keyValueStack = [Stack new];
    _objectKeyStack = [Stack new];
    _identifierStack = [Stack new];
    
    return self ?:nil;
}

- (SEScript *)assemble
{
    return _script;
}

#pragma mark - Assembler


- (void)parser:(PKParser *)parser didMatchScript:(PKAssembly *)assembly
{
    id element = nil;
    while ((element = [_elementStack pop]) != nil) {
        [_script.elements insertObject:element atIndex:0];
    }
}

- (void)parser:(PKParser *)parser didMatchElement:(PKAssembly *)assembly
{
    id elem;
    if ((elem = [_valueStack pop])) {
        [_elementStack push:elem];
        return;
    }
    if ((elem = [_methodChainStack pop])) {
        [_elementStack push:elem];
        return;
    }
    if ((elem = [_wordsStack pop])) {
        [_elementStack push:elem];
        return;
    }
}

- (void)parser:(PKParser *)parser didMatchWords:(PKAssembly *)assembly
{
    NSString *character = [_characterStack pop];
    NSArray *arguments = [_argumentsStack pop];
    SEWords *words = [[SEWords alloc] initWithCharacter:character arguments:arguments];
    [_wordsStack push:words];
}

- (void)parser:(PKParser *)parser didMatchMethodChain:(PKAssembly *)assembly
{
    NSString *target;
    SEMethodChain *chain;
    if((target = [_characterStack pop])){
        chain = [[SEMethodChain alloc] initWithTarget:target type:SEMethodChainTypeCharacterSpecified];
    }
    if ((target = [_identifierStack pop])){
        chain = [[SEMethodChain alloc] initWithTarget:target type:SEMethodChainTypeNormal];
    }
    SEMethod *m = nil;
    while ((m = [_methodStack pop]) != nil) {
        [chain.methods insertObject:m atIndex:0];
    }
    NSUInteger first = [[chain.methods firstObject] lineNumber];
    NSUInteger last = [[chain.methods lastObject] lineNumber];
    NSRange range = NSMakeRange(first, last-first+1);
    chain.rangeOfLines = range;
    [_methodChainStack push:chain];
}

- (void)parser:(PKParser *)parser didMatchCharacter:(PKAssembly *)assembly
{
    NSString *character = [_nameStack pop];
    [_characterStack push:character];
}

- (void)parser:(PKParser *)parser didMatchName:(PKAssembly *)assembly
{
    NSString *name = [[[assembly pop] stringValue] dequotedString];
    [_nameStack push:name];
}

- (void)parser:(PKParser *)parser didMatchMethod:(PKAssembly *)assembly
{
    NSArray *args = [_argumentsStack pop];
    NSString *identifier = [_identifierStack pop];
    SEMethod *method = [[SEMethod alloc] initWithName:identifier lineNumer:parser.tokenizer.lineNumber];
    [method setArguments:args];
    [_methodStack push:method];
}

- (void)parser:(PKParser *)parser didMatchArguments:(PKAssembly *)assembly
{
    id value = nil;
    NSMutableArray *ma = [NSMutableArray new];
    while ((value = [_valueStack pop]) != nil) {
        [ma insertObject:value atIndex:0];
    }
    if (ma.count > 0) {
        [_argumentsStack push:[NSArray arrayWithArray:ma]];
    }else{
        [_argumentsStack push:@[]];
    }
}

- (void)parser:(PKParser *)parser didMatchValue:(PKAssembly *)assembly
{
    id obj = [_objectStack pop];
    if (obj) {
        [_valueStack push:obj];
        return;
    }
    obj = [_arrayStack pop];
    if (obj) {
        [_valueStack push:obj];
        return;
    }
    PKToken *tok = [assembly pop];
    if (tok.tokenType == PKTokenTypeQuotedString){
        // quoteを外す
        NSString *s = [tok.stringValue substringWithRange:NSMakeRange(1, tok.stringValue.length-2)];
        [_valueStack push:s];
    }else if (tok.tokenType == PKTokenTypeNumber) {
        // NSNumber
        NSNumber *num = tok.value;
        [_valueStack push:num];
    }else if (tok.tokenType == PKTokenTypeWord){
        if (tok.tokenKind == SESCRIPTPARSER_TOKEN_KIND_FALSE) {
            [_valueStack push:@NO];
        }else if (tok.tokenKind == SESCRIPTPARSER_TOKEN_KIND_TRUE){
            [_valueStack push:@YES];
        }else if (tok.tokenKind == SESCRIPTPARSER_TOKEN_KIND_NULL){
            [_valueStack push:[NSNull null]];
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
        value = [_valueStack pop];
        [ma insertObject:value atIndex:0];
    }
    [assembly pop];
    [_arrayStack push:[NSArray arrayWithArray:ma]];
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
        keyValue = [_keyValueStack pop];
        NSString *key = keyValue[0];
        id obj = keyValue[1];
        [di setObject:obj forKey:key];
    }
    [assembly pop];
    [_objectStack push:[NSDictionary dictionaryWithDictionary:di]];
}

- (void)parser:(PKParser *)parser didMatchKeyValue:(PKAssembly *)assembly
{
    NSString *key = [_objectKeyStack pop];
    id value = [_valueStack pop];
    NSArray *keyValue = @[key,value];
    [_keyValueStack push:keyValue];
}

- (void)parser:(PKParser *)parser didMatchObjectKey:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    NSString *key = tok.stringValue;
    if (tok.tokenType == PKTokenTypeQuotedString){
        key = [key substringWithRange:NSMakeRange(1, tok.stringValue.length-2)];
    }
    [_objectKeyStack push:key];
}

- (void)parser:(PKParser *)parser didMatchIdentifier:(PKAssembly *)assembly
{
    PKToken *tok = [assembly pop];
    [_identifierStack push:tok.stringValue];
}


@end
