#import <ParseKit/PKSParser.h>

enum {
    SESCRIPT2_TOKEN_KIND_COMMA = 14,
    SESCRIPT2_TOKEN_KIND_COLON,
    SESCRIPT2_TOKEN_KIND_ANIMATESYM,
    SESCRIPT2_TOKEN_KIND_WS,
    SESCRIPT2_TOKEN_KIND_WORDSSYM,
    SESCRIPT2_TOKEN_KIND_DOSYM,
    SESCRIPT2_TOKEN_KIND_WAITSYM,
    SESCRIPT2_TOKEN_KIND_SETSYM,
    SESCRIPT2_TOKEN_KIND_TAPSYM,
    SESCRIPT2_TOKEN_KIND_PXSYM,
    SESCRIPT2_TOKEN_KIND_LAYERSYM,
    SESCRIPT2_TOKEN_KIND_OPEN_BRACKET,
    SESCRIPT2_TOKEN_KIND_VPXSYM,
    SESCRIPT2_TOKEN_KIND_PERCENTSYM,
    SESCRIPT2_TOKEN_KIND_CREATESYM,
    SESCRIPT2_TOKEN_KIND_CLOSE_BRACKET,
    SESCRIPT2_TOKEN_KIND_TEXTSYM,
    SESCRIPT2_TOKEN_KIND_OPEN_CURLY,
    SESCRIPT2_TOKEN_KIND_DELETESYM,
    SESCRIPT2_TOKEN_KIND_CHARACTERSYM,
    SESCRIPT2_TOKEN_KIND_ANIMATIONSYM,
    SESCRIPT2_TOKEN_KIND_CLOSE_CURLY,
};

@interface SEScript2Parser : PKSParser

@end


@class PKParser, PKAssembly;
@protocol SEScript2ParserDelegate <NSObject>
@required

- (void)parser:(PKParser*)parser didMatchWs:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchAnimateSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchDoSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchCreateSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchDeleteSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchSetSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWaitSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchLayerSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchCharacterSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchTextSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchAnimationSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchTapSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWordsSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchPxSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchVpxSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchPercentSym:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchScript:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchElement:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWords:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchTargetStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchAnimateStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchAnonymousStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchObjectStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchObjectIdentifier:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchSetStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchDoStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWaitStep:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWaitIdentifier:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArguments:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArgument:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchUnitValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchUnit:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchPoint:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchRect:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchIdentifier:(PKAssembly*)assembly;

@end

