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
@property (nonatomic, retain) NSMutableDictionary *ws_memo;
@property (nonatomic, retain) NSMutableDictionary *animateSym_memo;
@property (nonatomic, retain) NSMutableDictionary *doSym_memo;
@property (nonatomic, retain) NSMutableDictionary *createSym_memo;
@property (nonatomic, retain) NSMutableDictionary *deleteSym_memo;
@property (nonatomic, retain) NSMutableDictionary *setSym_memo;
@property (nonatomic, retain) NSMutableDictionary *waitSym_memo;
@property (nonatomic, retain) NSMutableDictionary *layerSym_memo;
@property (nonatomic, retain) NSMutableDictionary *characterSym_memo;
@property (nonatomic, retain) NSMutableDictionary *textSym_memo;
@property (nonatomic, retain) NSMutableDictionary *animationSym_memo;
@property (nonatomic, retain) NSMutableDictionary *tapSym_memo;
@property (nonatomic, retain) NSMutableDictionary *wordsSym_memo;
@property (nonatomic, retain) NSMutableDictionary *pxSym_memo;
@property (nonatomic, retain) NSMutableDictionary *vpxSym_memo;
@property (nonatomic, retain) NSMutableDictionary *percentSym_memo;
@property (nonatomic, retain) NSMutableDictionary *script_memo;
@property (nonatomic, retain) NSMutableDictionary *element_memo;
@property (nonatomic, retain) NSMutableDictionary *words_memo;
@property (nonatomic, retain) NSMutableDictionary *step_memo;
@property (nonatomic, retain) NSMutableDictionary *targetStep_memo;
@property (nonatomic, retain) NSMutableDictionary *animateStep_memo;
@property (nonatomic, retain) NSMutableDictionary *anonymousStep_memo;
@property (nonatomic, retain) NSMutableDictionary *objectStep_memo;
@property (nonatomic, retain) NSMutableDictionary *objectIdentifier_memo;
@property (nonatomic, retain) NSMutableDictionary *setStep_memo;
@property (nonatomic, retain) NSMutableDictionary *doStep_memo;
@property (nonatomic, retain) NSMutableDictionary *waitStep_memo;
@property (nonatomic, retain) NSMutableDictionary *waitIdentifier_memo;
@property (nonatomic, retain) NSMutableDictionary *arguments_memo;
@property (nonatomic, retain) NSMutableDictionary *argument_memo;
@property (nonatomic, retain) NSMutableDictionary *value_memo;
@property (nonatomic, retain) NSMutableDictionary *unitValue_memo;
@property (nonatomic, retain) NSMutableDictionary *unit_memo;
@property (nonatomic, retain) NSMutableDictionary *point_memo;
@property (nonatomic, retain) NSMutableDictionary *rect_memo;
@property (nonatomic, retain) NSMutableDictionary *identifier_memo;
@end

@implementation SEScript2Parser

- (id)init {
    self = [super init];
    if (self) {
        self._tokenKindTab[@","] = @(SESCRIPT2_TOKEN_KIND_COMMA);
        self._tokenKindTab[@":"] = @(SESCRIPT2_TOKEN_KIND_COLON);
        self._tokenKindTab[@"animate"] = @(SESCRIPT2_TOKEN_KIND_ANIMATESYM);
        self._tokenKindTab[@" "] = @(SESCRIPT2_TOKEN_KIND_WS);
        self._tokenKindTab[@"words"] = @(SESCRIPT2_TOKEN_KIND_WORDSSYM);
        self._tokenKindTab[@"do"] = @(SESCRIPT2_TOKEN_KIND_DOSYM);
        self._tokenKindTab[@"wait"] = @(SESCRIPT2_TOKEN_KIND_WAITSYM);
        self._tokenKindTab[@"set"] = @(SESCRIPT2_TOKEN_KIND_SETSYM);
        self._tokenKindTab[@"tap"] = @(SESCRIPT2_TOKEN_KIND_TAPSYM);
        self._tokenKindTab[@"px"] = @(SESCRIPT2_TOKEN_KIND_PXSYM);
        self._tokenKindTab[@"layer"] = @(SESCRIPT2_TOKEN_KIND_LAYERSYM);
        self._tokenKindTab[@"["] = @(SESCRIPT2_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"vpx"] = @(SESCRIPT2_TOKEN_KIND_VPXSYM);
        self._tokenKindTab[@"%"] = @(SESCRIPT2_TOKEN_KIND_PERCENTSYM);
        self._tokenKindTab[@"create"] = @(SESCRIPT2_TOKEN_KIND_CREATESYM);
        self._tokenKindTab[@"]"] = @(SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"text"] = @(SESCRIPT2_TOKEN_KIND_TEXTSYM);
        self._tokenKindTab[@"{"] = @(SESCRIPT2_TOKEN_KIND_OPEN_CURLY);
        self._tokenKindTab[@"delete"] = @(SESCRIPT2_TOKEN_KIND_DELETESYM);
        self._tokenKindTab[@"character"] = @(SESCRIPT2_TOKEN_KIND_CHARACTERSYM);
        self._tokenKindTab[@"animation"] = @(SESCRIPT2_TOKEN_KIND_ANIMATIONSYM);
        self._tokenKindTab[@"}"] = @(SESCRIPT2_TOKEN_KIND_CLOSE_CURLY);

        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_COMMA] = @",";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_COLON] = @":";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_ANIMATESYM] = @"animate";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_WS] = @" ";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_WORDSSYM] = @"words";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_DOSYM] = @"do";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_WAITSYM] = @"wait";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_SETSYM] = @"set";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_TAPSYM] = @"tap";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_PXSYM] = @"px";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_LAYERSYM] = @"layer";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_VPXSYM] = @"vpx";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_PERCENTSYM] = @"%";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CREATESYM] = @"create";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_TEXTSYM] = @"text";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_OPEN_CURLY] = @"{";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_DELETESYM] = @"delete";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CHARACTERSYM] = @"character";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_ANIMATIONSYM] = @"animation";
        self._tokenKindNameTab[SESCRIPT2_TOKEN_KIND_CLOSE_CURLY] = @"}";

        self.ws_memo = [NSMutableDictionary dictionary];
        self.animateSym_memo = [NSMutableDictionary dictionary];
        self.doSym_memo = [NSMutableDictionary dictionary];
        self.createSym_memo = [NSMutableDictionary dictionary];
        self.deleteSym_memo = [NSMutableDictionary dictionary];
        self.setSym_memo = [NSMutableDictionary dictionary];
        self.waitSym_memo = [NSMutableDictionary dictionary];
        self.layerSym_memo = [NSMutableDictionary dictionary];
        self.characterSym_memo = [NSMutableDictionary dictionary];
        self.textSym_memo = [NSMutableDictionary dictionary];
        self.animationSym_memo = [NSMutableDictionary dictionary];
        self.tapSym_memo = [NSMutableDictionary dictionary];
        self.wordsSym_memo = [NSMutableDictionary dictionary];
        self.pxSym_memo = [NSMutableDictionary dictionary];
        self.vpxSym_memo = [NSMutableDictionary dictionary];
        self.percentSym_memo = [NSMutableDictionary dictionary];
        self.script_memo = [NSMutableDictionary dictionary];
        self.element_memo = [NSMutableDictionary dictionary];
        self.words_memo = [NSMutableDictionary dictionary];
        self.step_memo = [NSMutableDictionary dictionary];
        self.targetStep_memo = [NSMutableDictionary dictionary];
        self.animateStep_memo = [NSMutableDictionary dictionary];
        self.anonymousStep_memo = [NSMutableDictionary dictionary];
        self.objectStep_memo = [NSMutableDictionary dictionary];
        self.objectIdentifier_memo = [NSMutableDictionary dictionary];
        self.setStep_memo = [NSMutableDictionary dictionary];
        self.doStep_memo = [NSMutableDictionary dictionary];
        self.waitStep_memo = [NSMutableDictionary dictionary];
        self.waitIdentifier_memo = [NSMutableDictionary dictionary];
        self.arguments_memo = [NSMutableDictionary dictionary];
        self.argument_memo = [NSMutableDictionary dictionary];
        self.value_memo = [NSMutableDictionary dictionary];
        self.unitValue_memo = [NSMutableDictionary dictionary];
        self.unit_memo = [NSMutableDictionary dictionary];
        self.point_memo = [NSMutableDictionary dictionary];
        self.rect_memo = [NSMutableDictionary dictionary];
        self.identifier_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_ws_memo removeAllObjects];
    [_animateSym_memo removeAllObjects];
    [_doSym_memo removeAllObjects];
    [_createSym_memo removeAllObjects];
    [_deleteSym_memo removeAllObjects];
    [_setSym_memo removeAllObjects];
    [_waitSym_memo removeAllObjects];
    [_layerSym_memo removeAllObjects];
    [_characterSym_memo removeAllObjects];
    [_textSym_memo removeAllObjects];
    [_animationSym_memo removeAllObjects];
    [_tapSym_memo removeAllObjects];
    [_wordsSym_memo removeAllObjects];
    [_pxSym_memo removeAllObjects];
    [_vpxSym_memo removeAllObjects];
    [_percentSym_memo removeAllObjects];
    [_script_memo removeAllObjects];
    [_element_memo removeAllObjects];
    [_words_memo removeAllObjects];
    [_step_memo removeAllObjects];
    [_targetStep_memo removeAllObjects];
    [_animateStep_memo removeAllObjects];
    [_anonymousStep_memo removeAllObjects];
    [_objectStep_memo removeAllObjects];
    [_objectIdentifier_memo removeAllObjects];
    [_setStep_memo removeAllObjects];
    [_doStep_memo removeAllObjects];
    [_waitStep_memo removeAllObjects];
    [_waitIdentifier_memo removeAllObjects];
    [_arguments_memo removeAllObjects];
    [_argument_memo removeAllObjects];
    [_value_memo removeAllObjects];
    [_unitValue_memo removeAllObjects];
    [_unit_memo removeAllObjects];
    [_point_memo removeAllObjects];
    [_rect_memo removeAllObjects];
    [_identifier_memo removeAllObjects];
}

- (void)__ws {
    
    [self match:SESCRIPT2_TOKEN_KIND_WS discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchWs:)];
}

- (void)ws {
    [self parseRule:@selector(__ws) withMemo:_ws_memo];
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

- (void)__layerSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_LAYERSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchLayerSym:)];
}

- (void)layerSym {
    [self parseRule:@selector(__layerSym) withMemo:_layerSym_memo];
}

- (void)__characterSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_CHARACTERSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchCharacterSym:)];
}

- (void)characterSym {
    [self parseRule:@selector(__characterSym) withMemo:_characterSym_memo];
}

- (void)__textSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_TEXTSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchTextSym:)];
}

- (void)textSym {
    [self parseRule:@selector(__textSym) withMemo:_textSym_memo];
}

- (void)__animationSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_ANIMATIONSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchAnimationSym:)];
}

- (void)animationSym {
    [self parseRule:@selector(__animationSym) withMemo:_animationSym_memo];
}

- (void)__tapSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_TAPSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchTapSym:)];
}

- (void)tapSym {
    [self parseRule:@selector(__tapSym) withMemo:_tapSym_memo];
}

- (void)__wordsSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_WORDSSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchWordsSym:)];
}

- (void)wordsSym {
    [self parseRule:@selector(__wordsSym) withMemo:_wordsSym_memo];
}

- (void)__pxSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_PXSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchPxSym:)];
}

- (void)pxSym {
    [self parseRule:@selector(__pxSym) withMemo:_pxSym_memo];
}

- (void)__vpxSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_VPXSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchVpxSym:)];
}

- (void)vpxSym {
    [self parseRule:@selector(__vpxSym) withMemo:_vpxSym_memo];
}

- (void)__percentSym {
    
    [self match:SESCRIPT2_TOKEN_KIND_PERCENTSYM discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchPercentSym:)];
}

- (void)percentSym {
    [self parseRule:@selector(__percentSym) withMemo:_percentSym_memo];
}

- (void)_start {
    
    [self execute:(id)^{
    
        PKTokenizer *t = self.tokenizer;
        
        // whitespace
      self.silentlyConsumesWhitespace = NO;
      self.assembly.preservesWhitespaceTokens = NO;

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
    } else if ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]) {
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
    
    do {
        [self matchAny:NO]; 
    } while ([self predicts:TOKEN_KIND_BUILTIN_ANY, 0]);

    [self fireAssemblerSelector:@selector(parser:didMatchWords:)];
}

- (void)words {
    [self parseRule:@selector(__words) withMemo:_words_memo];
}

- (void)__step {
    
    [self match:SESCRIPT2_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self targetStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_CREATESYM, SESCRIPT2_TOKEN_KIND_DELETESYM, SESCRIPT2_TOKEN_KIND_DOSYM, SESCRIPT2_TOKEN_KIND_SETSYM, SESCRIPT2_TOKEN_KIND_WAITSYM, 0]) {
        [self anonymousStep]; 
    } else {
        [self raise:@"No viable alternative found in rule 'step'."];
    }
    [self match:SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchStep:)];
}

- (void)step {
    [self parseRule:@selector(__step) withMemo:_step_memo];
}

- (void)__targetStep {
    
    [self identifier]; 
    [self ws]; 
    if ([self predicts:SESCRIPT2_TOKEN_KIND_ANIMATESYM, 0]) {
        [self animateStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_CREATESYM, SESCRIPT2_TOKEN_KIND_DELETESYM, SESCRIPT2_TOKEN_KIND_DOSYM, SESCRIPT2_TOKEN_KIND_SETSYM, SESCRIPT2_TOKEN_KIND_WAITSYM, 0]) {
        [self anonymousStep]; 
    } else {
        [self raise:@"No viable alternative found in rule 'targetStep'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchTargetStep:)];
}

- (void)targetStep {
    [self parseRule:@selector(__targetStep) withMemo:_targetStep_memo];
}

- (void)__animateStep {
    
    [self animateSym]; 
    [self ws]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchAnimateStep:)];
}

- (void)animateStep {
    [self parseRule:@selector(__animateStep) withMemo:_animateStep_memo];
}

- (void)__anonymousStep {
    
    if ([self predicts:SESCRIPT2_TOKEN_KIND_CREATESYM, SESCRIPT2_TOKEN_KIND_DELETESYM, 0]) {
        [self objectStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_SETSYM, 0]) {
        [self setStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_DOSYM, 0]) {
        [self doStep]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_WAITSYM, 0]) {
        [self waitStep]; 
    } else {
        [self raise:@"No viable alternative found in rule 'anonymousStep'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchAnonymousStep:)];
}

- (void)anonymousStep {
    [self parseRule:@selector(__anonymousStep) withMemo:_anonymousStep_memo];
}

- (void)__objectStep {
    
    if ([self predicts:SESCRIPT2_TOKEN_KIND_CREATESYM, 0]) {
        [self createSym]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_DELETESYM, 0]) {
        [self deleteSym]; 
    } else {
        [self raise:@"No viable alternative found in rule 'objectStep'."];
    }
    [self ws]; 
    [self objectIdentifier]; 
    [self ws]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchObjectStep:)];
}

- (void)objectStep {
    [self parseRule:@selector(__objectStep) withMemo:_objectStep_memo];
}

- (void)__objectIdentifier {
    
    if ([self predicts:SESCRIPT2_TOKEN_KIND_LAYERSYM, 0]) {
        [self layerSym]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_CHARACTERSYM, 0]) {
        [self characterSym]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_TEXTSYM, 0]) {
        [self textSym]; 
    } else {
        [self raise:@"No viable alternative found in rule 'objectIdentifier'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchObjectIdentifier:)];
}

- (void)objectIdentifier {
    [self parseRule:@selector(__objectIdentifier) withMemo:_objectIdentifier_memo];
}

- (void)__setStep {
    
    [self setSym]; 
    [self ws]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchSetStep:)];
}

- (void)setStep {
    [self parseRule:@selector(__setStep) withMemo:_setStep_memo];
}

- (void)__doStep {
    
    [self doSym]; 
    [self ws]; 
    [self identifier]; 
    [self arguments]; 

    [self fireAssemblerSelector:@selector(parser:didMatchDoStep:)];
}

- (void)doStep {
    [self parseRule:@selector(__doStep) withMemo:_doStep_memo];
}

- (void)__waitStep {
    
    [self waitSym]; 
    [self ws]; 
    [self waitIdentifier]; 

    [self fireAssemblerSelector:@selector(parser:didMatchWaitStep:)];
}

- (void)waitStep {
    [self parseRule:@selector(__waitStep) withMemo:_waitStep_memo];
}

- (void)__waitIdentifier {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_NUMBER, 0]) {
        [self matchNumber:NO]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_TAPSYM, 0]) {
        [self tapSym]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_ANIMATIONSYM, 0]) {
        [self animationSym]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_WORDSSYM, 0]) {
        [self wordsSym]; 
    } else {
        [self raise:@"No viable alternative found in rule 'waitIdentifier'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchWaitIdentifier:)];
}

- (void)waitIdentifier {
    [self parseRule:@selector(__waitIdentifier) withMemo:_waitIdentifier_memo];
}

- (void)__arguments {
    
    if ([self predicts:TOKEN_KIND_BUILTIN_WORD, 0]) {
        [self argument]; 
        while ([self predicts:SESCRIPT2_TOKEN_KIND_WS, 0]) {
            if ([self speculate:^{ [self ws]; [self argument]; }]) {
                [self ws]; 
                [self argument]; 
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
    } else if ([self speculate:^{ [self rect]; }]) {
        [self rect]; 
    } else {
        [self raise:@"No viable alternative found in rule 'value'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchValue:)];
}

- (void)value {
    [self parseRule:@selector(__value) withMemo:_value_memo];
}

- (void)__unitValue {
    
    [self matchNumber:NO]; 
    [self unit]; 

    [self fireAssemblerSelector:@selector(parser:didMatchUnitValue:)];
}

- (void)unitValue {
    [self parseRule:@selector(__unitValue) withMemo:_unitValue_memo];
}

- (void)__unit {
    
    if ([self predicts:SESCRIPT2_TOKEN_KIND_PXSYM, 0]) {
        [self pxSym]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_VPXSYM, 0]) {
        [self vpxSym]; 
    } else if ([self predicts:SESCRIPT2_TOKEN_KIND_PERCENTSYM, 0]) {
        [self percentSym]; 
    } else {
        [self raise:@"No viable alternative found in rule 'unit'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchUnit:)];
}

- (void)unit {
    [self parseRule:@selector(__unit) withMemo:_unit_memo];
}

- (void)__point {
    
    [self match:SESCRIPT2_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self unitValue]; 
    [self match:SESCRIPT2_TOKEN_KIND_COMMA discard:NO]; 
    [self unitValue]; 
    [self match:SESCRIPT2_TOKEN_KIND_CLOSE_CURLY discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchPoint:)];
}

- (void)point {
    [self parseRule:@selector(__point) withMemo:_point_memo];
}

- (void)__rect {
    
    [self match:SESCRIPT2_TOKEN_KIND_OPEN_CURLY discard:NO]; 
    [self point]; 
    [self match:SESCRIPT2_TOKEN_KIND_COMMA discard:NO]; 
    [self point]; 
    [self match:SESCRIPT2_TOKEN_KIND_CLOSE_CURLY discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchRect:)];
}

- (void)rect {
    [self parseRule:@selector(__rect) withMemo:_rect_memo];
}

- (void)__identifier {
    
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchIdentifier:)];
}

- (void)identifier {
    [self parseRule:@selector(__identifier) withMemo:_identifier_memo];
}

@end