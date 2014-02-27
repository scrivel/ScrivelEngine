//
//  SEScriptTests.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/11.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEScript.h"
#import "SEMethodChain.h"

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

- (void)testMethodChain
{
    NSError *e = nil;
    SEScript *s = [SEScript scriptWithString:@"layer.at(1).position(100,100).size(1,2,3)" error:&e];
    XCTAssertNil(e, );
    XCTAssert(s.elements.count == 1, );
    XCTAssert([s.elements[0] isKindOfClass:[SEMethodChain class]], );
    SEMethodChain *c = [s.elements lastObject];
    XCTAssert(c.methods.count == 3, );
    XCTAssert([[c.methods[0] name] isEqualToString:@"at"], );
    XCTAssert([[c.methods[1] name] isEqualToString:@"position"], );
    XCTAssert([[c.methods[2] name] isEqualToString:@"size"], );
    SEMethod *m = c.methods[2];
    XCTAssert([m integerArgAtIndex:0] == 1,);
    XCTAssert([m integerArgAtIndex:1] == 2,);
    XCTAssert([m integerArgAtIndex:2] == 3,);
}

- (void)testString
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"sample" ofType:@"sescript"];
    NSError *e = nil;
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
    SEScript *s = [SEScript scriptWithString:script error:&e];
    XCTAssertNil(e,);
    XCTAssert(s, );
    NSLog(@"%@",s);
    for (SEElement *elm in s.elements) {
        XCTAssert([elm isKindOfClass:[SEElement class]], );
    }
    NSLog(@"%@",e);
}

@end
