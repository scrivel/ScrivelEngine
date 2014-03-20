#import "SETextParser.h"
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

@interface SETextParser ()
@property (nonatomic, retain) NSMutableDictionary *text_memo;
@property (nonatomic, retain) NSMutableDictionary *string_memo;
@property (nonatomic, retain) NSMutableDictionary *tag_memo;
@property (nonatomic, retain) NSMutableDictionary *html_memo;
@property (nonatomic, retain) NSMutableDictionary *identifier_memo;
@end

@implementation SETextParser

- (id)init {
    self = [super init];
    if (self) {
        self._tokenKindTab[@"]"] = @(SETEXTPARSER_TOKEN_KIND_CLOSE_BRACKET);
        self._tokenKindTab[@"["] = @(SETEXTPARSER_TOKEN_KIND_OPEN_BRACKET);
        self._tokenKindTab[@"/"] = @(SETEXTPARSER_TOKEN_KIND_FORWARD_SLASH);
        self._tokenKindTab[@">"] = @(SETEXTPARSER_TOKEN_KIND_GT);
        self._tokenKindTab[@"<"] = @(SETEXTPARSER_TOKEN_KIND_LT);

        self._tokenKindNameTab[SETEXTPARSER_TOKEN_KIND_CLOSE_BRACKET] = @"]";
        self._tokenKindNameTab[SETEXTPARSER_TOKEN_KIND_OPEN_BRACKET] = @"[";
        self._tokenKindNameTab[SETEXTPARSER_TOKEN_KIND_FORWARD_SLASH] = @"/";
        self._tokenKindNameTab[SETEXTPARSER_TOKEN_KIND_GT] = @">";
        self._tokenKindNameTab[SETEXTPARSER_TOKEN_KIND_LT] = @"<";

        self.text_memo = [NSMutableDictionary dictionary];
        self.string_memo = [NSMutableDictionary dictionary];
        self.tag_memo = [NSMutableDictionary dictionary];
        self.html_memo = [NSMutableDictionary dictionary];
        self.identifier_memo = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)_clearMemo {
    [_text_memo removeAllObjects];
    [_string_memo removeAllObjects];
    [_tag_memo removeAllObjects];
    [_html_memo removeAllObjects];
    [_identifier_memo removeAllObjects];
}

- (void)_start {
    
    [self text]; 
    [self matchEOF:YES]; 

}

- (void)__text {
    
    if ([self predicts:SETEXTPARSER_TOKEN_KIND_OPEN_BRACKET, 0]) {
        [self tag]; 
    } else if ([self predicts:SETEXTPARSER_TOKEN_KIND_LT, 0]) {
        [self html]; 
    } else if ([self predicts:) {
        [self string]; 
    } else {
        [self raise:@"No viable alternative found in rule 'text'."];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchText:)];
}

- (void)text {
    [self parseRule:@selector(__text) withMemo:_text_memo];
}

- (void)__string {
    
    static NSRegularExpression *regex = nil;
    if (!regex) {
        NSError *err = nil;
        regex = [[NSRegularExpression regularExpressionWithPattern:@"\[\^\\\[\\]<>]\+" options:NSRegularExpressionCaseInsensitive error:&err] retain];
        if (!regex) {
            if (err) NSLog(@"%@", err);
        }
    }
    
    NSString *str = LS(1);
    
    if ([regex numberOfMatchesInString:str options:0 range:NSMakeRange(0, [str length])]) {
        [self match:TOKEN_KIND_BUILTIN_ANY discard:NO];
    } else {
        [self raise:@"pattern test failed in string"];
    }

    [self fireAssemblerSelector:@selector(parser:didMatchString:)];
}

- (void)string {
    [self parseRule:@selector(__string) withMemo:_string_memo];
}

- (void)__tag {
    
    [self match:SETEXTPARSER_TOKEN_KIND_OPEN_BRACKET discard:NO]; 
    [self identifier]; 
    [self match:SETEXTPARSER_TOKEN_KIND_CLOSE_BRACKET discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchTag:)];
}

- (void)tag {
    [self parseRule:@selector(__tag) withMemo:_tag_memo];
}

- (void)__html {
    
    [self match:SETEXTPARSER_TOKEN_KIND_LT discard:NO]; 
    [self identifier]; 
    [self match:SETEXTPARSER_TOKEN_KIND_GT discard:NO]; 
    [self text]; 
    [self match:SETEXTPARSER_TOKEN_KIND_LT discard:NO]; 
    [self match:SETEXTPARSER_TOKEN_KIND_FORWARD_SLASH discard:NO]; 
    [self identifier]; 
    [self match:SETEXTPARSER_TOKEN_KIND_GT discard:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchHtml:)];
}

- (void)html {
    [self parseRule:@selector(__html) withMemo:_html_memo];
}

- (void)__identifier {
    
    [self matchWord:NO]; 

    [self fireAssemblerSelector:@selector(parser:didMatchIdentifier:)];
}

- (void)identifier {
    [self parseRule:@selector(__identifier) withMemo:_identifier_memo];
}

@end
