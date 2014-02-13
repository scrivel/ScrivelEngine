//
//  PKToken+ScrivelEngine.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "PKToken+ScrivelEngine.h"

@implementation PKToken (ScrivelEngine)

- (BOOL)isStartOfMethod
{
    return (self.tokenType == PKTokenTypeSymbol && [self.stringValue isEqualToString:@"("]);
}

- (BOOL)isEndOfMethod
{
    return (self.tokenType == PKTokenTypeSymbol && [self.stringValue isEqualToString:@")"]);
}

- (BOOL)isDotChain
{
    return (self.tokenType == PKTokenTypeSymbol && [self.stringValue isEqualToString:@"."]);
}

- (BOOL)isCommna
{
    return (self.tokenType == PKTokenTypeSymbol && [self.stringValue isEqualToString:@","]);
}

- (BOOL)isHyphen
{
    return (self.tokenType == PKTokenTypeSymbol && [self.stringValue isEqualToString:@"-"]);
}

@end
