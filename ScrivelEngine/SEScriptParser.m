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
@property (nonatomic, retain) NSMutableDictionary *openWord_memo;
@property (nonatomic, retain) NSMutableDictionary *closeWord_memo;
@property (nonatomic, retain) NSMutableDictionary *line_memo;
@property (nonatomic, retain) NSMutableDictionary *words_memo;
@property (nonatomic, retain) NSMutableDictionary *name_memo;
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@property (nonatomic, retain) NSMutableDictionary *tag_memo;
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
        self._tokenKindTab[@"」"] = @(SESCRIPTPARSER_TOKEN_KIND_CLOSEWORD);
        self._tokenKindTab[@":"] = @(SESCRIPTPARSER_TOKEN_KIND_COLON);
        self._tokenKindTab[@","] = @(SESCRIPTPARSER_TOKEN_KIND_COMMA);
        self._tokenKindTab[@"<"] = @(SESCRIPTPARSER_TOKEN_KIND_LT);
        self._tokenKindTab[@"["] = @(SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"."] = @(SESCRIPTPARSER_TOKEN_KIND_DOT);
        self._tokenKindTab[@"{"] = @(SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY);
        self._tokenKindTab[@">"] = @(SESCRIPTPARSER_TOKEN_KIND_GT);
        self._tokenKindTab[@"]"] = @(SESCRIPTPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"("] = @(SESCRIPTPARSER_TOKEN_KIND_OPEN_PAREN);
        self._tokenKindTab[@"}"] = @(SESCRIPTPARSER_TOKEN_KIND_CLOSE_CURLY);
        self._tokenKindTab[@")"] = @(SESCRIPTPARSER_TOKEN_KIND_CLOSE_PAREN);
        self._tokenKindTab[@"「"] = @(SESCRIPTPARSER_TOKEN_KIND_OPENWORD);

        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_CLOSEWORD] = @"」";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_COLON] = @":";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_COMMA] = @",";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_LT] = @"<";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_DOT] = @".";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY] = @"{";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_GT] = @">";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_OPEN_PAREN] = @"(";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_CLOSE_PAREN] = @")";
        self._tokenKindNameTab[SESCRIPTPARSER_TOKEN_KIND_OPENWORD] = @"「";

        self.openWord_memo = [NSMutableDictionary dictionary];
        self.closeWord_memo = [NSMutableDictionary dictionary];
        self.line_memo = [NSMutableDictionary dictionary];
        self.words_memo = [NSMutableDictionary dictionary];
        self.name_memo = [NSMutableDictionary dictionary];
        self.text_memo = [NSMutableDictionary dictionary];
        self.tag_memo = [NSMutableDictionary dictionary];
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
    [_openWord_memo removeAllObjects];
    [_closeWord_memo removeAllObjects];
    [_line_memo removeAllObjects];
    [_words_memo removeAllObjects];
    [_name_memo removeAllObjects];
    [_text_memo removeAllObjects];
    [_tag_memo removeAllObjects];
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
    
    [self line]; 
    [self matchEOF:YES]; 

}

- (void)__openWord {
    
    [self match:SESCRIPTPARSER_TOKEN_KIND_OPENWORD discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchOpenWord:)];
}

- (void)openWord {
    [self parseRule:@selector(__openWord) withMemo:_openWord_memo];
}

- (void)__closeWord {
    
    [self match:SESCRIPTPARSER_TOKEN_KIND_CLOSEWORD discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchCloseWord:)];
}

- (void)closeWord {
    [self parseRule:@selector(__closeWord) withMemo:_closeWord_memo];
}

- (void)__line {
    
    if ([self speculate:^{ [self matchComment:NO]; }]) {
        [self matchComment:NO]; 
    } else if ([self speculate:^{ [self method]; while ([self predicts:SESCRIPTPARSER_TOKEN_KIND_DOT, 0]) {if ([self speculate:^{ [self match:SESCRIPTPARSER_TOKEN_KIND_DOT discard:NO]; [self method]; }]) {[self match:SESCRIPTPARSER_TOKEN_KIND_DOT discard:NO]; [self method]; } else {break;}}}]) {
        [self method]; 
        while ([self predicts:SESCRIPTPARSER_TOKEN_KIND_DOT, 0]) {
            if ([self speculate:^{ [self match:SESCRIPTPARSER_TOKEN_KIND_DOT discard:NO]; [self method]; }]) {
                [self match:SESCRIPTPARSER_TOKEN_KIND_DOT discard:NO]; 
                [self method]; 
            } else {
                break;
            }
        }
    } else if ([self speculate:^{ [self words]; }]) {
        [self words]; 
    } else {
        [self raise:@"No viable alternative found in rule 'line'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchLine:)];
}

- (void)line {
    [self parseRule:@selector(__line) withMemo:_line_memo];
}

- (void)__words {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self name]; 
    }
    [self openWord]; 
    [self text]; 
    [self closeWord]; 

    [self fireAssemblerSelector:@selector(parser:didMatchWords:)];
}

- (void)words {
    [self parseRule:@selector(__words) withMemo:_words_memo];
}

- (void)__name {
    
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchName:)];
}

- (void)name {
    [self parseRule:@selector(__name) withMemo:_name_memo];
}

- (void)__text {
    
    do {
        if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
            [self matchWord:NO]; 
        } else if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_LT, 0]) {
            [self tag]; 
        } else {
            [self raise:@"No viable alternative found in rule 'text'."];
        }
    } while ([self speculate:^{ if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {[self matchWord:NO]; } else if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_LT, 0]) {[self tag]; } else {[self raise:@"No viable alternative found in rule 'text'."];}}]);

    [self fireAssemblerSelector:@selector(parser:didMatchText:)];
}

- (void)text {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

- (void)__tag {
    
    [self match:SESCRIPTPARSER_TOKEN_KIND_LT discard:NO]; 
    [self identifier]; 
    [self match:SESCRIPTPARSER_TOKEN_KIND_GT discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchTag:)];
}

- (void)tag {
    [self parseRule:@selector(__tag) withMemo:_tag_memo];
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
    
    if ([self predicts:SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET, SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY, TOKEN_KIND_BUILTIN_NUMBER, TOKEN_KIND_BUILTIN_QUOTEDSTRING, 0]) {
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
        [self identifier]; 
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