//
//  SEScriptTests.m
//  PetiteCouturiere
//
//  Created by keroxp on 2014/02/11.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEScript.h"
#import "SEMethodChain.h"
#import "SEWords.h"

@interface SEScriptTests : XCTestCase
{
    NSArray *_testScriptPaths;
}
@end

@implementation SEScriptTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    _testScriptPaths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"sescript" inDirectory:@"Scripts.bundle"];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testMethodChain
{
    NSError *e = nil;
    SEScript *s = [SEScript scriptWithString:@"layer.at(1).position(100,100).size(1,2,3);" error:&e];
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

- (void)testMethodChain2
{
    NSError *e = nil;
    SEScript *s = [SEScript scriptWithString:@"{\"かえるくん\"}.do(\"jump\",1).did().will();" error:&e];
    XCTAssertNil(e, );
    XCTAssert(s.elements.count == 1, );
    SEMethodChain *chain = s.elements[0];
    XCTAssert(chain.type == SEMethodChainTypeCharacterSpecified, );
    XCTAssert(chain.methods.count == 3, );
    XCTAssert([chain.target isEqualToString:@"かえるくん"], );
    XCTAssert([[chain.methods[0] name] isEqualToString:@"do"], );
    XCTAssert([[chain.methods[1] name] isEqualToString:@"did"], );
    XCTAssert([[chain.methods[2] name] isEqualToString:@"will"], );
}

- (void)testWords
{
    NSString *w = @"{\"かえるくん\"}(\"せりふ\",{duration : 1.0});";
    NSError *e = nil;
    SEScript *s = [SEScript scriptWithString:w error:&e];
    XCTAssertNil(e, );
    XCTAssert(s, );
    XCTAssert(s.elements.count == 1, );
    SEWords *elem = s.elements[0];
    XCTAssert([elem isKindOfClass:[SEWords class]], );
    XCTAssert([elem.character isEqualToString:@"かえるくん"], );
    XCTAssert([elem.text isEqualToString:@"せりふ"], );
    XCTAssert([elem.options[@"duration"] unsignedIntegerValue] == 1, );
}

- (void)testScriptString
{
    for (NSString *path in _testScriptPaths) {
        NSError *e = nil;
        NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
        SEScript *s = [SEScript scriptWithString:script error:&e];
        XCTAssertNil(e, );
        XCTAssert(s, );
    }
}

@end
