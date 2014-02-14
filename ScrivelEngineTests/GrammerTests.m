//
//  GrammerTests.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/14.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ParseKit/ParseKit.h>

@interface GrammerTests : XCTestCase

@end

@implementation GrammerTests

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

//- (void)testExample
//{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"javascript" ofType:@"grammer"];
//    NSError * e = nil;
//    NSString *g = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
//    XCTAssertNil(e, );
//    PKParser *p = [[PKParserFactory factory] parserFromGrammar:g assembler:self error:&e];
//    XCTAssertNil(e, );
//    XCTAssertNotNil(p, );
//}

@end
