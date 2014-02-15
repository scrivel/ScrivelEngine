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
#import <objc/runtime.h>

@interface Stack : NSObject

- (id)pop;
- (void)push:(id)obj;

@end

@implementation Stack
{
    NSMutableArray *ma;
}
- (id)init
{
    self = [super init];
    if (self) {
        ma = [NSMutableArray new];
    }
    return self;
}

- (id)pop
{
    id obj = [ma lastObject];
    [ma removeLastObject];
    return obj;
}

- (void)push:(id)obj
{
    [ma addObject:obj];
}

@end

@interface SEScriptAssembler (Stack)

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

#pragma mark -

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

//- (void)forwardInvocation:(NSInvocation *)anInvocation
//{
//    NSString *selector = NSStringFromSelector(anInvocation.selector);
//    // popHoge or pushHoge:
//    if ([selector hasPrefix:@"pop"]) {
//        // popHoge -> Hoge
//        NSRange range = NSMakeRange(3, selector.length-3);
//        NSString *key = [selector substringWithRange:range];
//        NSMutableArray *stack = [_stacks objectForKey:key];
//        id obj = [stack lastObject];
//        [stack removeLastObject];
//        [anInvocation setReturnValue:&obj];
//    }else if ([selector hasPrefix:@"push"]){
//        // pushHoge: -> Hoge
//        NSRange range = NSMakeRange(4, selector.length-5);
//        NSString *key = [selector substringWithRange:range];
//        NSMutableArray *stack = [_stacks objectForKey:key];
//        if (!stack) {
//            stack = [NSMutableArray new];
//            [_stacks setObject:stack forKey:key];
//            stack = [_stacks objectForKey:key];
//        }
//        id obj = nil;
//        [anInvocation getArgument:&obj atIndex:2];
//        [stack addObject:obj];
//    }
//}

//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
//{
//    const char * type = [[self class] returnTypeForMissingSelector:aSelector];
//    if ([NSStringFromSelector(aSelector) hasPrefix:@"push"]) {
//        NSString *types = [NSString stringWithFormat:@"%s%s%s%s", @encode(void), @encode(id), @encode(SEL), type];
//        return [NSMethodSignature signatureWithObjCTypes:[types UTF8String]];
//    }else{
//        NSString *types = [NSString stringWithFormat:@"%s%s%s", type, @encode(id), @encode(SEL)];
//        return [NSMethodSignature signatureWithObjCTypes:[types UTF8String]];
//    }
//}
//
//+ (const char *)returnTypeForMissingSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(popElement)
//        || aSelector == @selector(pushElement:)) {
//        return @encode(SEElement*);
//    }else if (aSelector == @selector(popMethodChain)
//              || aSelector == @selector(pushMethodChain:)){
//        return @encode(SEMethodChain*);
//    }else if (aSelector == @selector(popMethod)
//              || aSelector == @selector(pushMethod:)) {
//        return @encode(SEMethod*);
//    }else if (aSelector == @selector(popArguments)
//              || aSelector == @selector(pushArguments:)){
//        return @encode(NSArray*);
//    }else if (aSelector == @selector(popObject)
//              || aSelector == @selector(pushObject:)){
//        return @encode(NSDictionary*);
//    }else if (aSelector == @selector(popArray)
//              || aSelector == @selector(pushArray:)){
//        return @encode(NSArray*);
//    }else if (aSelector == @selector(popValue)
//              || aSelector == @selector(pushValue:)){
//        return @encode(id);
//    }else if (aSelector == @selector(popKeyValue)
//              || aSelector == @selector(pushKeyValue:)){
//        return @encode(NSArray*);
//    }else if (aSelector == @selector(popKey)
//              || aSelector == @selector(pushKey:)){
//        return @encode(NSString*);
//    }else if (aSelector == @selector(popIdentifier)
//              || aSelector == @selector(pushIdentifier:)){
//        return @encode(NSString*);
//    }else if (aSelector == @selector(popName)
//              || aSelector == @selector(pushName:)) {
//        return @encode(NSString*);
//    }else if (aSelector == @selector(popText)
//              || aSelector == @selector(pushText:)){
//        return @encode(NSString*);
//    }
//    return @encode(void);
//}

#pragma mark - Assembler


- (void)parser:(PKParser *)parser didMatchScript:(PKAssembly *)assembly{
    SEElement *element = nil;
    while ((element = [self popElement]) != nil) {
        [_script addElement:element];
    }
}

- (void)parser:(PKParser *)parser didMatchElement:(PKAssembly *)assembly{
    // メソッドチェーンかセリフをpush
    id pop = [self popMethodChain];
//    [self pushElement:pop];
    [_script addElement:pop];
}

- (void)parser:(PKParser *)parser didMatchMethodChain:(PKAssembly *)assembly
{
    SEMethodChain *chain = [[SEMethodChain alloc] initWithLineNumber:parser.tokenizer.lineNumber];
    SEMethod *m = nil;
    while ((m = [self popMethod]) != nil) {
        [chain addMethod:m];
    }
    [self pushMethodChain:chain];
}

- (void)parser:(PKParser *)parser didMatchMethod:(PKAssembly *)assembly
{
    NSArray *args = [self popArguments];
    NSString *identifier = [self popIdentifier];
    SEMethod *method = nil;
    if (args) {
        method = [[SEMethod alloc] initWithName:identifier type:SEScriptTypeMethodCall];
        [method setArguments:args];
    }else{
        method = [[SEMethod alloc] initWithName:identifier type:SEScriptTypeAccessor];
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
        [chain addMethod:name_m];
    }
    SEMethod *text_m = [SEMethod textMethod];
    [text_m setArguments:@[text]];
    [chain addMethod:text_m];
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

@end
