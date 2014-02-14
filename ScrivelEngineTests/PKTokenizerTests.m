//
//  PKTokenizerTests.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/14.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ParseKit/ParseKit.h>

@interface PKTokenizerTests : XCTestCase

@end

@implementation PKTokenizerTests

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

- (void)testExample
{
    static NSString *s = @"漢字かな交じりの文章にapp.hoge()とかあったり？";
    PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
    PKToken *tok = nil;
    PKToken *eof = [PKToken EOFToken];
    while ((tok = [t nextToken]) != eof) {
        NSLog(@"(%@) (%.1f) : %@", tok.stringValue, tok.floatValue, [tok debugDescription]);
    }
}

@end
