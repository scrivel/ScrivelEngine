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


@class PKParser, PKAssembly;
@protocol SEScript2ParserDelegate <NSObject>
@required

- (void)parser:(PKParser*)parser didMatchArrow:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchAnimateSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchDoSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchCreateSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchDeleteSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchSetSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWaitSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchScript:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchElement:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWords:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchSpeaker:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchAnimateStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchCreateStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchDeleteStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchSetStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchDoStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWaitStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArguments:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArgument:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchBool:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchUnitValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchPoint:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchSize:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchIdentifier:(PKAssembly*)assembly;

@end

