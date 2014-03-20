#import <ParseKit/PKSParser.h>

enum {
    SETEXTPARSER_TOKEN_KIND_CLOSE_BRACKET = 14,
    SETEXTPARSER_TOKEN_KIND_OPEN_BRACKET,
    SETEXTPARSER_TOKEN_KIND_FORWARD_SLASH,
    SETEXTPARSER_TOKEN_KIND_GT,
    SETEXTPARSER_TOKEN_KIND_LT,
};

@interface SETextParser : PKSParser

@end

@class PKParser, PKAssembly;
@protocol SETextParserDelegate <NSObject>
@required

- (void)parser:(PKParser*)parser didMatchText:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchString:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchTag:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchHtml:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchIdentifier:(PKAssembly*)assembly;

@end

