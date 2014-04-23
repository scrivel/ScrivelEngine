//
//  SEScriptAssembler.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>
#import "SEScriptParser.h"

@protocol SEScriptParserDelegate;
@class SEScript;

@interface SEScriptAssembler : NSObject
<SEScriptParserDelegate>

- (SEScript*)assemble;

@end