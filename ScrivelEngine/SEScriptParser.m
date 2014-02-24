#import "SEScriptParser.h"
#import <ParseKit/ParseKit.h>

#define LT(i) [self LT:(i)]
#define LA(i) [self LA:(i)]
#define LS(i) [self LS:(i)]
#define LF(i) [self LF:(i)]

#define POP()       [self.assembly pop]
#define POP_STR()   [self _popString]
#define POP_TOK()   [self _popToken]
#define POP_BOOL()  [self _popBool]
#define POP_INT()   [self _popInteger]
#define POP_FLOAT() [self _popDouble]

#define PUSH(obj)     [self.assembly push:(id)(obj)]
#define PUSH_BOOL(yn) [self _pushBool:(BOOL)(yn)]
#define PUSH_INT(i)   [self _pushInteger:(NSInteger)(i)]
#define PUSH_FLOAT(f) [self _pushDouble:(double)(f)]

#define EQ(a, b) [(a) isEqual:(b)]
#define NE(a, b) (![(a) isEqual:(b)])
#define EQ_IGNORE_CASE(a, b) (NSOrderedSame == [(a) compare:(b)])

#define ABOVE(fence) [self.assembly objectsAbove:(fence)]

#define LOG(obj) do { NSLog(@"%@", (obj)); } while (0);
#define PRINT(str) do { printf("%s\n", (str)); } while (0);

@interface PKSParser ()
@property (nonatomic, retain) NSMutableDictionary *_tokenKindTab;
@property (nonatomic, retain) NSMutableArray *_tokenKindNameTab;

- (BOOL)_popBool;
- (NSInteger)_popInteger;
- (double)_popDouble;
- (PKToken *)_popToken;
- (NSString *)_popString;

- (void)_pushBool:(BOOL)yn;
- (void)_pushInteger:(NSInteger)i;
- (void)_pushDouble:(double)d;
@end

@interface SEScriptParser ()
@property (nonatomic, retain) NSMutableDictionary *script_memo;
@property (nonatomic, retain) NSMutableDictionary *element_memo;
@property (nonatomic, retain) NSMutableDictionary *words_memo;
@property (nonatomic, retain) NSMutableDictionary *name_memo;
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@property (nonatomic, retain) NSMutableDictionary *methodChain_memo;
@property (nonatomic, retain) NSMutableDictionary *method_memo;
@property (nonatomic, retain) NSMutableDictionary *arguments_memo;
@property (nonatomic, retain) NSMutableDictionary *value_memo;
@property (nonatomic, retain) NSMutableDictionary *array_memo;
@property (nonatomic, retain) NSMutableDictionary *object_memo;
@property (nonatomic, retain) NSMutableDictionary *keyValue_memo;
@property (nonatomic, retain) NSMutableDictionary *key_memo;
@property (nonatomic, retain) NSMutableDictionary *identifier_memo;
@end

@implementation SEScriptParser

- (id)init {
    self = [super init];
    if (self) {
        self._tokenKindTab[@":"] = @(SESCRIPTPARSER_TOKEN_KIND_COLON);
        self._tokenKindTab[@"false"] = @(SESCRIPTPARSER_TOKEN_KIND_FALSE);
        self._tokenKindTab[@";"] = @(SESCRIPTPARSER_TOKEN_KIND_SEMI_COLON);
        self._tokenKindTab[@","] = @(SESCRIPTPARSER_TOKEN_KIND_COMMA);
        self._tokenKindTab[@"["] = @(SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"true"] = @(SESCRIPTPARSER_TOKEN_KIND_TRUE);
        self._tokenKindTab[@"."] = @(SESCRIPTPARSER_TOKEN_KIND_DOT);
        self._tokenKindTab[@"{"] = @(SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY);
        self._tokenKindTab[@"null"] = @(SESCRIPTPARSER_TOKEN_KIND_NULL);
        self._tokenKindTab[@"]"] = @(SESCRIPTPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"("] = @(SESCRIPTPARSER_TOKEN_KIND_OPEN_PAREN);
        self._tokenKindTab[@"}"] = @(SESCRIPTPARSER_TOKEN_KIND_CLOSE_CURLY);
        self._tokenKindTab[@")"] = @(SESCRIPTPARSER_TOKEN_KIND_CLOSE_PAREN);

        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_COLON] = @":";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_FALSE] = @"false";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_SEMI_COLON] = @";";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_COMMA] = @",";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_TRUE] = @"true";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_DOT] = @".";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY] = @"{";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_NULL] = @"null";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";

        self.script_memo = [NSMutableDictionary dictionary];
        self.element_memo = [NSMutableDictionary dictionary];
        self.words_memo = [NSMutableDictionary dictionary];
        self.name_memo = [NSMutableDictionary dictionary];
        self.text_memo = [NSMutableDictionary dictionary];
        self.methodChain_memo = [NSMutableDictionary dictionary];
        self.method_memo = [NSMutableDictionary dictionary];
        self.arguments_memo = [NSMutableDictionary dictionary];
        self.value_memo = [NSMutableDictionary dictionary];
        self.array_memo = [NSMutableDictionary dictionary];
        self.object_memo = [NSMutableDictionary dictionary];
        self.keyValue_memo = [NSMutableDictionary dictionary];
        self.key_memo = [NSMutableDictionary dictionary];
        self.identifier_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_script_memo removeAllObjects];
    [_element_memo removeAllObjects];
    [_words_memo removeAllObjects];
    [_name_memo removeAllObjects];
    [_text_memo removeAllObjects];
    [_methodChain_memo removeAllObjects];
    [_method_memo removeAllObjects];
    [_arguments_memo removeAllObjects];
    [_value_memo removeAllObjects];
    [_array_memo removeAllObjects];
    [_object_memo removeAllObjects];
    [_keyValue_memo removeAllObjects];
    [_key_memo removeAllObjects];
    [_identifier_memo removeAllObjects];
}

- (void)_start {
    
    [self script]; 
    [self matchEOF:YES]; 

}

- (void)__script {
    
    do {
        [self element]; 
    } while ([self speculate:^{ [self element]; }]);

    [self fireAssemblerSelector:@selector(parser:didMatchScript:)];
}

- (void)script {
    [self parseRule:@selector(__script) withMemo:_script_memo];
}

- (void)__element {
    
    if ([self speculate:^{ [self matchComment:NO]; }]) {
        [self matchComment:NO]; 
    } else if ([self speculate:^{ [self words]; }]) {
        [self words]; 
    } else if ([self speculate:^{ [self methodChain]; }]) {
        [self methodChain]; 
    } else if ([self speculate:^{ [self value]; }]) {
        [self value]; 
    } else {
        [self raise:@"No viable alternative found in rule 'element'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchElement:)];
}

- (void)element {
    [self parseRule:@selector(__element) withMemo:_element_memo];
}

- (void)__words {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self name]; 
    }
    [self match:SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self text]; 
    [self match:SESCRIPTPARSER_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchWords:)];
}

- (void)words {
    [self parseRule:@selector(__words) withMemo:_words_memo];
}

- (void)__name {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'name'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchName:)];
}

- (void)name {
    [self parseRule:@selector(__name) withMemo:_name_memo];
}

- (void)__text {
    
    do {
        if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self matchWord:NO]; 
        } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
            [self matchQuotedString:NO]; 
        } else if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
            [self matchNumber:NO]; 
        } else {
            [self raise:@"No viable alternative found in rule 'text'."];
        }
    } while ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, TOKEN_KIND_BUILTIN_WORD, 0]);

    [self fireAssemblerSelector:@selector(parser:didMatchText:)];
}

- (void)text {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

- (void)__methodChain {
    
    [self identifier]; 
    while ([self predicts:SESCRIPTPARSER_TOKEN_KIND_DOT, 0]) {
        if ([self speculate:^{ [self match:SESCRIPTPARSER_TOKEN_KIND_DOT discard:NO]; [self method]; }]) {
            [self match:SESCRIPTPARSER_TOKEN_KIND_DOT discard:NO]; 
            [self method]; 
        } else {
            break;
        }
    }
    if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_SEMI_COLON, 0]) {
        [self match:SESCRIPTPARSER_TOKEN_KIND_SEMI_COLON discard:NO]; 
    }

    [self fireAssemblerSelector:@selector(parser:didMatchMethodChain:)];
}

- (void)methodChain {
    [self parseRule:@selector(__methodChain) withMemo:_methodChain_memo];
}

- (void)__method {
    
    [self identifier]; 
    if ([self speculate:^{ [self match:SESCRIPTPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; [self arguments]; [self match:SESCRIPTPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; }]) {
        [self match:SESCRIPTPARSER_TOKEN_KIND_OPEN_PAREN discard:NO]; 
        [self arguments]; 
        [self match:SESCRIPTPARSER_TOKEN_KIND_CLOSE_PAREN discard:NO]; 
    }

    [self fireAssemblerSelector:@selector(parser:didMatchMethod:)];
}

- (void)method {
    [self parseRule:@selector(__method) withMemo:_method_memo];
}

- (void)__arguments {
    
    if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_FALSE, SESCRIPTPARSER_TOKEN_KIND_NULL, SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET, SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY, SESCRIPTPARSER_TOKEN_KIND_TRUE, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self value]; 
        while ([self predicts:SESCRIPTPARSER_TOKEN_KIND_COMMA, 0]) {
            if ([self speculate:^{ [self match:SESCRIPTPARSER_TOKEN_KIND_COMMA discard:NO]; [self value]; }]) {
                [self match:SESCRIPTPARSER_TOKEN_KIND_COMMA discard:NO]; 
                [self value]; 
            } else {
                break;
            }
        }
    }

    [self fireAssemblerSelector:@selector(parser:didMatchArguments:)];
}

- (void)arguments {
    [self parseRule:@selector(__arguments) withMemo:_arguments_memo];
}

- (void)__value {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
    } else if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self array]; 
    } else if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY, 0]) {
        [self object]; 
    } else if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_TRUE, 0]) {
        [self match:SESCRIPTPARSER_TOKEN_KIND_TRUE discard:NO]; 
    } else if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_FALSE, 0]) {
        [self match:SESCRIPTPARSER_TOKEN_KIND_FALSE discard:NO]; 
    } else if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_NULL, 0]) {
        [self match:SESCRIPTPARSER_TOKEN_KIND_NULL discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'value'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchValue:)];
}

- (void)value {
    [self parseRule:@selector(__value) withMemo:_value_memo];
}

- (void)__array {
    
    [self match:SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self value]; 
    while ([self predicts:SESCRIPTPARSER_TOKEN_KIND_COMMA, 0]) {
        if ([self speculate:^{ [self match:SESCRIPTPARSER_TOKEN_KIND_COMMA discard:NO]; [self value]; }]) {
            [self match:SESCRIPTPARSER_TOKEN_KIND_COMMA discard:NO]; 
            [self value]; 
        } else {
            break;
        }
    }
    [self match:SESCRIPTPARSER_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchArray:)];
}

- (void)array {
    [self parseRule:@selector(__array) withMemo:_array_memo];
}

- (void)__object {
    
    [self match:SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self keyValue]; 
    while ([self predicts:SESCRIPTPARSER_TOKEN_KIND_COMMA, 0]) {
        if ([self speculate:^{ [self match:SESCRIPTPARSER_TOKEN_KIND_COMMA discard:NO]; [self keyValue]; }]) {
            [self match:SESCRIPTPARSER_TOKEN_KIND_COMMA discard:NO]; 
            [self keyValue]; 
        } else {
            break;
        }
    }
    [self match:SESCRIPTPARSER_TOKEN_KIND_CLOSE_CURLY discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchObject:)];
}

- (void)object {
    [self parseRule:@selector(__object) withMemo:_object_memo];
}

- (void)__keyValue {
    
    [self key]; 
    [self match:SESCRIPTPARSER_TOKEN_KIND_COLON discard:NO]; 
    [self value]; 

    [self fireAssemblerSelector:@selector(parser:didMatchKeyValue:)];
}

- (void)keyValue {
    [self parseRule:@selector(__keyValue) withMemo:_keyValue_memo];
}

- (void)__key {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self matchWord:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
        [self matchQuotedString:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'key'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchKey:)];
}

- (void)key {
    [self parseRule:@selector(__key) withMemo:_key_memo];
}

- (void)__identifier {
    
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchIdentifier:)];
}

- (void)identifier {
    [self parseRule:@selector(__identifier) withMemo:_identifier_memo];
}

@end