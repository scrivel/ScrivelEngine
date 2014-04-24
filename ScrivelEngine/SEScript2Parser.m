#import "SEScript2Parser.h"
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

@interface SEScript2Parser ()
@property (nonatomic, retain) NSMutableDictionary *arrow_memo;
@property (nonatomic, retain) NSMutableDictionary *animateSym_memo;
@property (nonatomic, retain) NSMutableDictionary *doSym_memo;
@property (nonatomic, retain) NSMutableDictionary *createSym_memo;
@property (nonatomic, retain) NSMutableDictionary *deleteSym_memo;
@property (nonatomic, retain) NSMutableDictionary *setSym_memo;
@property (nonatomic, retain) NSMutableDictionary *waitSym_memo;
@property (nonatomic, retain) NSMutableDictionary *script_memo;
@property (nonatomic, retain) NSMutableDictionary *element_memo;
@property (nonatomic, retain) NSMutableDictionary *words_memo;
@property (nonatomic, retain) NSMutableDictionary *speaker_memo;
@property (nonatomic, retain) NSMutableDictionary *step_memo;
@property (nonatomic, retain) NSMutableDictionary *animateStep_memo;
@property (nonatomic, retain) NSMutableDictionary *createStep_memo;
@property (nonatomic, retain) NSMutableDictionary *deleteStep_memo;
@property (nonatomic, retain) NSMutableDictionary *setStep_memo;
@property (nonatomic, retain) NSMutableDictionary *doStep_memo;
@property (nonatomic, retain) NSMutableDictionary *waitStep_memo;
@property (nonatomic, retain) NSMutableDictionary *arguments_memo;
@property (nonatomic, retain) NSMutableDictionary *argument_memo;
@property (nonatomic, retain) NSMutableDictionary *value_memo;
@property (nonatomic, retain) NSMutableDictionary *bool_memo;
@property (nonatomic, retain) NSMutableDictionary *unitValue_memo;
@property (nonatomic, retain) NSMutableDictionary *point_memo;
@property (nonatomic, retain) NSMutableDictionary *size_memo;
@property (nonatomic, retain) NSMutableDictionary *identifier_memo;
@end

@implementation SEScript2Parser

- (id)init {
    self = [super init];
    if (self) {
        self._tokenKindTab[@")"] = @(SESCRIPT2_TOKEN_KIND_CLOSE_PAREN);
        self._tokenKindTab[@"do"] = @(SESCRIPT2_TOKEN_KIND_DOSYM);
        self._tokenKindTab[@":"] = @(SESCRIPT2_TOKEN_KIND_COLON);
        self._tokenKindTab[@"}"] = @(SESCRIPT2_TOKEN_KIND_CLOSE_CURLY);
        self._tokenKindTab[@"<<"] = @(SESCRIPT2_TOKEN_KIND_ARROW);
        self._tokenKindTab[@","] = @(SESCRIPT2_TOKEN_KIND_COMMA);
        self._tokenKindTab[@"["] = @(SESCRIPT2_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"delete"] = @(SESCRIPT2_TOKEN_KIND_DELETESYM);
        self._tokenKindTab[@"{"] = @(SESCRIPT2_TOKEN_KIND_OPEN_CURLY);
        self._tokenKindTab[@"set"] = @(SESCRIPT2_TOKEN_KIND_SETSYM);
        self._tokenKindTab[@"]"] = @(SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"no"] = @(SESCRIPT2_TOKEN_KIND_NO);
        self._tokenKindTab[@"yes"] = @(SESCRIPT2_TOKEN_KIND_YES);
        self._tokenKindTab[@"create"] = @(SESCRIPT2_TOKEN_KIND_CREATESYM);
        self._tokenKindTab[@"("] = @(SESCRIPT2_TOKEN_KIND_OPEN_PAREN);
        self._tokenKindTab[@"wait"] = @(SESCRIPT2_TOKEN_KIND_WAITSYM);
        self._tokenKindTab[@"animate"] = @(SESCRIPT2_TOKEN_KIND_ANIMATESYM);

        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CLOSE_PAREN] = @")";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_DOSYM] = @"do";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_COLON] = @":";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CLOSE_CURLY] = @"}";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_ARROW] = @"<<";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_COMMA] = @",";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_DELETESYM] = @"delete";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_OPEN_CURLY] = @"{";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_SETSYM] = @"set";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_NO] = @"no";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_YES] = @"yes";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CREATESYM] = @"create";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_OPEN_PAREN] = @"(";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_WAITSYM] = @"wait";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_ANIMATESYM] = @"animate";

        self.arrow_memo = [NSMutableDictionary dictionary];
        self.animateSym_memo = [NSMutableDictionary dictionary];
        self.doSym_memo = [NSMutableDictionary dictionary];
        self.createSym_memo = [NSMutableDictionary dictionary];
        self.deleteSym_memo = [NSMutableDictionary dictionary];
        self.setSym_memo = [NSMutableDictionary dictionary];
        self.waitSym_memo = [NSMutableDictionary dictionary];
        self.script_memo = [NSMutableDictionary dictionary];
        self.element_memo = [NSMutableDictionary dictionary];
        self.words_memo = [NSMutableDictionary dictionary];
        self.speaker_memo = [NSMutableDictionary dictionary];
        self.step_memo = [NSMutableDictionary dictionary];
        self.animateStep_memo = [NSMutableDictionary dictionary];
        self.createStep_memo = [NSMutableDictionary dictionary];
        self.deleteStep_memo = [NSMutableDictionary dictionary];
        self.setStep_memo = [NSMutableDictionary dictionary];
        self.doStep_memo = [NSMutableDictionary dictionary];
        self.waitStep_memo = [NSMutableDictionary dictionary];
        self.arguments_memo = [NSMutableDictionary dictionary];
        self.argument_memo = [NSMutableDictionary dictionary];
        self.value_memo = [NSMutableDictionary dictionary];
        self.bool_memo = [NSMutableDictionary dictionary];
        self.unitValue_memo = [NSMutableDictionary dictionary];
        self.point_memo = [NSMutableDictionary dictionary];
        self.size_memo = [NSMutableDictionary dictionary];
        self.identifier_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_arrow_memo removeAllObjects];
    [_animateSym_memo removeAllObjects];
    [_doSym_memo removeAllObjects];
    [_createSym_memo removeAllObjects];
    [_deleteSym_memo removeAllObjects];
    [_setSym_memo removeAllObjects];
    [_waitSym_memo removeAllObjects];
    [_script_memo removeAllObjects];
    [_element_memo removeAllObjects];
    [_words_memo removeAllObjects];
    [_speaker_memo removeAllObjects];
    [_step_memo removeAllObjects];
    [_animateStep_memo removeAllObjects];
    [_createStep_memo removeAllObjects];
    [_deleteStep_memo removeAllObjects];
    [_setStep_memo removeAllObjects];
    [_doStep_memo removeAllObjects];
    [_waitStep_memo removeAllObjects];
    [_arguments_memo removeAllObjects];
    [_argument_memo removeAllObjects];
    [_value_memo removeAllObjects];
    [_bool_memo removeAllObjects];
    [_unitValue_memo removeAllObjects];
    [_point_memo removeAllObjects];
    [_size_memo removeAllObjects];
    [_identifier_memo removeAllObjects];
}

- (void)__arrow {
    
    [self match:SESCRIPT2_TOKEN_KIND_ARROW discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchArrow:)];
}

- (void)arrow {
    [self parseRule:@selector(__arrow) withMemo:_arrow_memo];
}

- (void)__animateSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_ANIMATESYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchAnimateSym:)];
}

- (void)animateSym {
    [self parseRule:@selector(__animateSym) withMemo:_animateSym_memo];
}

- (void)__doSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_DOSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchDoSym:)];
}

- (void)doSym {
    [self parseRule:@selector(__doSym) withMemo:_doSym_memo];
}

- (void)__createSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_CREATESYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchCreateSym:)];
}

- (void)createSym {
    [self parseRule:@selector(__createSym) withMemo:_createSym_memo];
}

- (void)__deleteSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_DELETESYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchDeleteSym:)];
}

- (void)deleteSym {
    [self parseRule:@selector(__deleteSym) withMemo:_deleteSym_memo];
}

- (void)__setSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_SETSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchSetSym:)];
}

- (void)setSym {
    [self parseRule:@selector(__setSym) withMemo:_setSym_memo];
}

- (void)__waitSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_WAITSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchWaitSym:)];
}

- (void)waitSym {
    [self parseRule:@selector(__waitSym) withMemo:_waitSym_memo];
}

- (void)_start {
    
    [self execute:(id)^{
    
        PKTokenizer *t = self.tokenizer;
        
        // whitespace
      self.silentlyConsumesWhitespace = NO;
      self.assembly.preservesWhitespaceTokens = YES;

    }];
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
    
    if ([self predicts:TOKEN_KIND_BUILTIN_COMMENT, 0]) {
        [self matchComment:NO]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self step]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self words]; 
    } else {
        [self raise:@"No viable alternative found in rule 'element'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchElement:)];
}

- (void)element {
    [self parseRule:@selector(__element) withMemo:_element_memo];
}

- (void)__words {
    
    if ([self speculate:^{ [self speaker]; }]) {
        [self speaker]; 
    }
    do {
        [self matchAny:NO]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]);

    [self fireAssemblerSelector:@selector(parser:didMatchWords:)];
}

- (void)words {
    [self parseRule:@selector(__words) withMemo:_words_memo];
}

- (void)__speaker {
    
    [self identifier]; 
    [self arrow]; 

    [self fireAssemblerSelector:@selector(parser:didMatchSpeaker:)];
}

- (void)speaker {
    [self parseRule:@selector(__speaker) withMemo:_speaker_memo];
}

- (void)__step {
    
    [self match:SESCRIPT2_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self identifier]; 
    }
    if ([self predicts:SESCRIPT2_TOKEN_KIND_SETSYM, 0]) {
        [self setStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_ANIMATESYM, 0]) {
        [self animateStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_DOSYM, 0]) {
        [self doStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_WAITSYM, 0]) {
        [self waitStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_CREATESYM, 0]) {
        [self createStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_DELETESYM, 0]) {
        [self deleteStep]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }
    [self match:SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchStep:)];
}

- (void)step {
    [self parseRule:@selector(__step) withMemo:_step_memo];
}

- (void)__animateStep {
    
    [self animateSym]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchAnimateStep:)];
}

- (void)animateStep {
    [self parseRule:@selector(__animateStep) withMemo:_animateStep_memo];
}

- (void)__createStep {
    
    [self createSym]; 
    [self identifier]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchCreateStep:)];
}

- (void)createStep {
    [self parseRule:@selector(__createStep) withMemo:_createStep_memo];
}

- (void)__deleteStep {
    
    [self deleteSym]; 
    [self identifier]; 

    [self fireAssemblerSelector:@selector(parser:didMatchDeleteStep:)];
}

- (void)deleteStep {
    [self parseRule:@selector(__deleteStep) withMemo:_deleteStep_memo];
}

- (void)__setStep {
    
    [self setSym]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchSetStep:)];
}

- (void)setStep {
    [self parseRule:@selector(__setStep) withMemo:_setStep_memo];
}

- (void)__doStep {
    
    [self doSym]; 
    [self identifier]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchDoStep:)];
}

- (void)doStep {
    [self parseRule:@selector(__doStep) withMemo:_doStep_memo];
}

- (void)__waitStep {
    
    [self waitSym]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
    } else if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self identifier]; 
    } else {
        [self raise:@"No viable alternative found in rule 'waitStep'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchWaitStep:)];
}

- (void)waitStep {
    [self parseRule:@selector(__waitStep) withMemo:_waitStep_memo];
}

- (void)__arguments {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        do {
            [self argument]; 
        } while ([self speculate:^{ [self argument]; }]);
    }

    [self fireAssemblerSelector:@selector(parser:didMatchArguments:)];
}

- (void)arguments {
    [self parseRule:@selector(__arguments) withMemo:_arguments_memo];
}

- (void)__argument {
    
    [self identifier]; 
    [self match:SESCRIPT2_TOKEN_KIND_COLON discard:NO]; 
    [self value]; 

    [self fireAssemblerSelector:@selector(parser:didMatchArgument:)];
}

- (void)argument {
    [self parseRule:@selector(__argument) withMemo:_argument_memo];
}

- (void)__value {
    
    if ([self speculate:^{ [self matchQuotedString:NO]; }]) {
        [self matchQuotedString:NO]; 
    } else if ([self speculate:^{ [self matchNumber:NO]; }]) {
        [self matchNumber:NO]; 
    } else if ([self speculate:^{ [self unitValue]; }]) {
        [self unitValue]; 
    } else if ([self speculate:^{ [self point]; }]) {
        [self point]; 
    } else if ([self speculate:^{ [self size]; }]) {
        [self size]; 
    } else if ([self speculate:^{ [self bool]; }]) {
        [self bool]; 
    } else {
        [self raise:@"No viable alternative found in rule 'value'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchValue:)];
}

- (void)value {
    [self parseRule:@selector(__value) withMemo:_value_memo];
}

- (void)__bool {
    
    if ([self predicts:SESCRIPT2_TOKEN_KIND_YES, 0]) {
        [self match:SESCRIPT2_TOKEN_KIND_YES discard:NO]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_NO, 0]) {
        [self match:SESCRIPT2_TOKEN_KIND_NO discard:NO]; 
    } else {
        [self raise:@"No viable alternative found in rule 'bool'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchBool:)];
}

- (void)bool {
    [self parseRule:@selector(__bool) withMemo:_bool_memo];
}

- (void)__unitValue {
    
    [self matchNumber:NO]; 
    [self identifier]; 

    [self fireAssemblerSelector:@selector(parser:didMatchUnitValue:)];
}

- (void)unitValue {
    [self parseRule:@selector(__unitValue) withMemo:_unitValue_memo];
}

- (void)__point {
    
    [self match:SESCRIPT2_TOKEN_KIND_OPEN_PAREN discard:NO]; 
    [self unitValue]; 
    [self match:SESCRIPT2_TOKEN_KIND_COMMA discard:NO]; 
    [self unitValue]; 
    [self match:SESCRIPT2_TOKEN_KIND_CLOSE_PAREN discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchPoint:)];
}

- (void)point {
    [self parseRule:@selector(__point) withMemo:_point_memo];
}

- (void)__size {
    
    [self match:SESCRIPT2_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self unitValue]; 
    [self match:SESCRIPT2_TOKEN_KIND_COMMA discard:NO]; 
    [self unitValue]; 
    [self match:SESCRIPT2_TOKEN_KIND_CLOSE_CURLY discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchSize:)];
}

- (void)size {
    [self parseRule:@selector(__size) withMemo:_size_memo];
}

- (void)__identifier {
    
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchIdentifier:)];
}

- (void)identifier {
    [self parseRule:@selector(__identifier) withMemo:_identifier_memo];
}

@end