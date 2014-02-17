#import <ParseKit/ParseKit.h>

enum {
    SESCRIPTPARSER_TOKEN_KIND_DOT = 14,
    SESCRIPTPARSER_TOKEN_KIND_COLON,
    SESCRIPTPARSER_TOKEN_KIND_CLOSE_CURLY,
    SESCRIPTPARSER_TOKEN_KIND_OPEN_BRACKET,
    SESCRIPTPARSER_TOKEN_KIND_COMMA,
    SESCRIPTPARSER_TOKEN_KIND_OPEN_PAREN,
    SESCRIPTPARSER_TOKEN_KIND_OPEN_CURLY,
    SESCRIPTPARSER_TOKEN_KIND_CLOSE_BRACKET,
    SESCRIPTPARSER_TOKEN_KIND_CLOSE_PAREN,
    SESCRIPTPARSER_TOKEN_KIND_SEMI_COLON,
};

@interface SEScriptParser : PKSParser

@end


@protocol SEScriptParserDelegate <NSObject>

- (void)parser:(PKParser*)parser didMatchScript:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchElement:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWords:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchName:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchText:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchMethodChain:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchMethod:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArguments:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArray:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchObject:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchKeyValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchKey:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchIdentifier:(PKAssembly*)assembly;

@end

