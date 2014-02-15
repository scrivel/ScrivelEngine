//
//  SEScriptTests.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/11.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEScript.h"
#import "SEGlobalObject.h"

//static inline void _testParseError(NSString *string, SEScriptParseError type) {
//    NSError *e = nil;
//    SEScript *s = [SEScript scriptWithString:string error:&e];
//    XCTAssertNil(s, @"エラーが起きてるから無い");
//    XCTAssertNotNil(e, @"エラーが起きてるから有る");
//    XCTAssert(e.code == type, );
//}

@interface SEScriptTests : XCTestCase

@end

@implementation SEScriptTests

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
    NSString *js = @"bg.at(1).position(0,0).transition(\"bg2\", 1, \"cross disolve\");";
    NSError *e = nil;
    SEScript *s = [SEScript scriptWithString:js error:&e];
    XCTAssertNil(e, @"エラーはないはず");
    if (e) {
        NSLog(@"%@",e);
    }
}

- (void)testToknizer
{
    NSString *s
    = @"hoge.\n\
    to.ho\n\
    ge()\n\
    複数行の\n\
    コメント";
    PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
    PKToken *tok = nil;
    while ((tok = [t nextToken]) != [PKToken EOFToken]) {
        NSLog(@"%@, %@",tok.stringValue,tok.description);
    }
}

- (void)testSample
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"sample" ofType:@"sescript"];
    NSError *e = nil;
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
    [SEScript scriptWithString:script error:&e];
    XCTAssertNil(e,);
    NSLog(@"%@",e);
}

- (void)testGlobal
{
    NSError *e = nil;
    SEScript *s =nil;
    s = [SEScript scriptWithString:@"hoge()" error:&e];
    XCTAssertNil(e, @"トップレベル関数の呼び出し");
}

- (void)testError
{
    NSError *e = nil;
    SEScript *s = nil;

    s = [SEScript scriptWithString:@"" error:&e];
    XCTAssert(e, @"そもそも文字列がない" ); e = nil;
    s = [SEScript scriptWithString:@"bg.hoge(2,)" error:&e];
    XCTAssert(e, @"引数が足りない" ); e = nil;
    s = [SEScript scriptWithString:@"bg..hoge()" error:&e];
    XCTAssert(e, @".が二回続いている" ); e = nil;
    s = [SEScript scriptWithString:@"bg.hoge(1,2)_hoge()" error:&e];
    XCTAssert(e, @"メソッドチェーンが.でない" ); e = nil;
}


@end
