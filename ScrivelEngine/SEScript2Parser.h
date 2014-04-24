#import <ParseKit/PKSParser.h>

enum {
    SESCRIPT2_TOKEN_KIND_CLOSE_PAREN = 14,
    SESCRIPT2_TOKEN_KIND_DOSYM,
    SESCRIPT2_TOKEN_KIND_COLON,
    SESCRIPT2_TOKEN_KIND_CLOSE_CURLY,
    SESCRIPT2_TOKEN_KIND_ARROW,
    SESCRIPT2_TOKEN_KIND_COMMA,
    SESCRIPT2_TOKEN_KIND_OPEN_BRACKET,
    SESCRIPT2_TOKEN_KIND_DELETESYM,
    SESCRIPT2_TOKEN_KIND_OPEN_CURLY,
    SESCRIPT2_TOKEN_KIND_SETSYM,
    SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET,
    SESCRIPT2_TOKEN_KIND_NO,
    SESCRIPT2_TOKEN_KIND_YES,
    SESCRIPT2_TOKEN_KIND_CREATESYM,
    SESCRIPT2_TOKEN_KIND_OPEN_PAREN,
    SESCRIPT2_TOKEN_KIND_WAITSYM,
    SESCRIPT2_TOKEN_KIND_ANIMATESYM,
};

@interface SEScript2Parser : PKSParser

@end

