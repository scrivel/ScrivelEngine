//
//  SEScript2Assembler.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>
#import "ScrivelEngine.h"
#import "SEScript2Parser.h"

@class SEScript2;

@interface SEScript2Assembler : NSObject<SEScript2ParserDelegate>

- (instancetype)initWithEngine:(ScrivelEngine*)engine;
- (SEScript2*)assemble;

@property (nonatomic, readonly, weak) ScrivelEngine *engine;

@end
