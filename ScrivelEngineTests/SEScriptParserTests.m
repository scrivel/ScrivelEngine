//
//  SEScriptParserTests.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/14.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEScriptParser.h"
#import <ParseKit/ParseKit.h>

@interface SEScriptParserTests : XCTestCase

@end

@implementation SEScriptParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testParse
{
    SEScriptParser *parser = [[SEScriptParser alloc] init];
    XCTAssert(parser, );
    NSError *e = nil;
    NSString *script = @"layer.at([1,2,4]).fadeIn(100).wait(100)";
    PKAssembly *as = [parser parseString:script assembler:nil error:&e];
    XCTAssertNil(e, );
//    NSString *script = @"hoge.to.path";
//    PKAssembly *as = [parser parseString:script assembler:self error:&e];
//    XCTAssertNil(e, );
    PKReleaseSubparserTree((PKParser*)parser);
    NSLog(@"%@",as);
    
}

- (void)parser:(PKParser*)parser didMatchProperty:(PKAssembly*)assembly
{
    NSLog(@"%@",assembly);
}

- (void)parser:(PKParser*)parser didMatchArguments:(PKAssembly*)assembly
{
    
}

- (void)parser:(PKParser*)parser didMatchValue:(PKAssembly *)assembly
{
    
}

- (void)parser:(PKParser*)parser didMatchCall:(PKAssembly*)assembly
{
    NSLog(@"%@",assembly);
}

@end
