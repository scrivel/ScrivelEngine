//
//  SEObjectTests.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "_SEObject.h"
#import "SEBasicObject.h"

@interface SEObjectTests : XCTestCase

@end

@implementation SEObjectTests

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

- (void)testSEObject
{
    @autoreleasepool {
        ScrivelEngine *e = [ScrivelEngine new];
        _SEObject *new = [[_SEObject alloc] initWithEngine:e];
        XCTAssert(new, );
    }
    @autoreleasepool {
        ScrivelEngine *e = [ScrivelEngine new];
        XCTAssert(e, );
    }
}

@end
