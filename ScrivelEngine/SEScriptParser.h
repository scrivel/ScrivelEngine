#import <ParseKit/PKSParser.h>

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

