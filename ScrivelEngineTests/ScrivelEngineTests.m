//
//  ScrivelEngineTests.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScrivelEngine.h"

@interface ScrivelEngineTests : XCTestCase

@end

@implementation ScrivelEngineTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testScript
{
    ScrivelEngine *engine = [ScrivelEngine new];
    XCTAssert(engine, );
    BOOL b;
    NSError *e = nil;
    XCTAssertNoThrow(b = [engine evaluateScript:@"layer.at(1).position(100,100)" error:&e], );
    XCTAssert(b, );
}

@end
