//
//  SEScript2Tests.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEScript2.h"
#import "SEAnimationStep.h"
#import "SECreateStep.h"

#define NEWENGINE [ScrivelEngine engineWithRootView:[[SEView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] virtualSize:CGSizeMake(320,480)]

@interface SEScript2Tests : XCTestCase
{
    NSArray *_testScriptPaths;
}
@end

@implementation SEScript2Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _testScriptPaths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"sescript2" inDirectory:@"Scripts.bundle"];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParse
{
    for (id path in _testScriptPaths) {
        NSError *e = nil;
        NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
        SEScript2 *s = [SEScript2 scriptWithString:script engine:NEWENGINE error:&e];
        XCTAssert(s, );
        XCTAssertNil(e, );
    }
}

- (void)testArguments
{
    NSString *str = @"[つむぎ animate in:3 moveBy:(0px, 100px) sizeTo:{100px, 200px} rotateBy:100 scaleTo:2 repeatBy:2 repeatIn:1 reverse:yes]";
    NSError *e = nil;
    SEScript2 *script = [SEScript2 scriptWithString:str engine:NEWENGINE error:&e];
    XCTAssertNil(e, );
    XCTAssert(script.elements.count == 1, );
    SEAnimationStep *step = script.elements[0];
    XCTAssert([step isKindOfClass:[SEAnimationStep class]], );
    XCTAssert(step.toKeyValues.count == 8, );
    XCTAssert([step.toKeyValues[@"in"] unsignedIntegerValue] == 3, );
    XCTAssert([step.toKeyValues[@"reverse"] boolValue] == YES, );
    SEUnitPoint *p = step.toKeyValues[@"moveBy"];
    XCTAssert([p.x.numberValue isEqual:@(0)], );
    XCTAssert([p.y.numberValue isEqual:@(100)], );
    SEUnitSize *s = step.toKeyValues[@"sizeTo"];
    XCTAssert([s.width.numberValue isEqual:@(100)], );
    XCTAssert([s.height.numberValue isEqual:@(200)], );
}

@end
