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
    NSString *js = @"bg.at(1).position(0,0).transition(\"bg2\", 1, \"cross disolve\")";
    NSError *e = nil;
    SEScript *s = [SEScript scriptWithString:js error:&e];
    XCTAssertNil(e, @"エラーはないはず");
    XCTAssert(s, @"ちゃんとある");
//    XCTAssert(s.target, @"targetがある");
    XCTAssert(s.methods.count == 4 , @"メソッドチェーンが4回");
    NSLog(@"%@",s.methods);
}

- (void)testGlobal
{
    NSError *e = nil;
    SEScript *s =nil;
    s = [SEScript scriptWithString:@"hoge()" error:&e];
    XCTAssertNil(e, @"トップレベル関数の呼び出し");
//    XCTAssert([s.target isKindOfClass:[SEGlobalObject class]], @"ターゲットがGlobalObjectになっている");
    XCTAssert(s.methods.count == 1, @"global.hoge()");
}

- (void)testObjectNotFound
{
//    NSError *e = nil;
//    SEScript *s = nil;
//    s = [SEScript scriptWithString:@"invalid.hoge()" error:&e];
//    XCTAssert(e.code == SEScriptParseErrorObjectNotFound, @"存在しないオブジェクト");
}

- (void)testObjectNotSpecified
{
    NSError *e = nil;
    SEScript *s = nil;
    s = [SEScript scriptWithString:@"" error:&e]; XCTAssert(e.code == SEScriptParseErrorNilStringGiven, @"そもそも文字列がない" ); e = nil;
}

- (void)testMehodNotCalled
{
    NSError *e = nil;
    SEScript *s = nil;
    s = [SEScript scriptWithString:@"bg" error:&e]; XCTAssert(e.code == SEScriptParseErrorMethodNotCalled, @"メソッドが呼ばれていない");
    s = [SEScript scriptWithString:@"bg.hoge.to" error:&e]; XCTAssert(e.code == SEScriptParseErrorMethodNotCalled, @"メソッドが呼ばれていない");
    s = [SEScript scriptWithString:@"bg.hoge.method().to" error:&e]; XCTAssert(e.code == SEScriptParseErrorMethodNotCalled, @"メソッドが呼ばれていない");
}

- (void)testUnexpectedToken
{
    NSError *e = nil;
    SEScript *s = nil;
//    s = [SEScript scriptWithString:@"bg." error:&e]; XCTAssert(e.code == SEScriptParseErrorUnexpectedToken, @"ハイフンで始まってない" ); e = nil;
    s = [SEScript scriptWithString:@"bg.hoge(2,)" error:&e]; XCTAssert(e.code == SEScriptParseErrorUnexpectedToken, @"引数が足りない" ); e = nil;
    s = [SEScript scriptWithString:@"bg..hoge()" error:&e]; XCTAssert(e.code == SEScriptParseErrorUnexpectedToken, @".が二回続いている" ); e = nil;
}

- (void)testUnexpectedToken2
{    
    NSError *e = nil;
    SEScript *s = nil;
    s = [SEScript scriptWithString:@"bg.hoge(1,2)_hoge()" error:&e]; XCTAssert(e.code == SEScriptParseErrorUnexpectedToken, @"メソッドチェーンが.でない" ); e = nil;
    s = [SEScript scriptWithString:@"bg.hoge() hoge()" error:&e]; XCTAssert(e.code == SEScriptParseErrorUnexpectedToken, @".がない" ); e = nil;
}


@end
