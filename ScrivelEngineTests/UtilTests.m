//
//  UtilTests.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/08.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Queue.h"

@interface UtilTests : XCTestCase

@end

@implementation UtilTests

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

- (void)testQueue
{
    Queue *q = [Queue new];
    [q enqueue:@1];
    XCTAssert([[q dequeue] isEqual:@1], );
    XCTAssert(q.count == 0, );
    [q enqueue:@1];
    [q enqueue:@0 prior:YES];
    XCTAssert([[q dequeue] isEqual:@0], );
    [q enqueueObjects:@[@2,@3]];
    XCTAssert([q.head isEqual:@1], );
    XCTAssert([q.tail isEqual:@3], );
    [q enqueueObjects:@[@(-2),@(-1)] prior:YES];
    XCTAssert([q.head isEqual: @(-2)], );
    XCTAssert([q.tail isEqual: @(3)], );
    XCTAssert([[q dequeue] isEqual: @(-2)], );
}

@end
