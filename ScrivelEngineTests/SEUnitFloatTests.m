//
//  SEUnitNumberTests.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEUnitValue.h"
#import "NSNumber+CGFloat.h"

@interface SEUnitValueTests : XCTestCase

@end

@implementation SEUnitValueTests

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

- (void)testBasics
{
    SEUnitValue *px = [SEUnitValue unitNumberWithValueDescription:@"10px"];
    XCTAssert([px.numberValue isEqual:@10], );
    XCTAssert(px.unitType == SEUnitTypePixels, );
    SEUnitValue *percent = [SEUnitValue unitNumberWithValueDescription:@"10%"];
    XCTAssert(percent.unitType == SEUnitTypePercentage, );
    XCTAssert([percent.numberValue isEqual:@10], );
    SEUnitValue *vpx = [SEUnitValue unitNumberWithValueDescription:@"10vpx"];
    XCTAssert([vpx.numberValue isEqual:@10], );
    XCTAssert(vpx.unitType == SEUnitTypeVirtualPixels, );
    SEUnitValue *normal = [SEUnitValue unitNumberWithValueDescription:@"10"];
    XCTAssert([normal.numberValue isEqual:@10], );
    XCTAssert(normal.unitType == SEUnitTypeDefault, );
    SEUnitValue *minus = [SEUnitValue unitNumberWithValueDescription:@"-100px"];
    XCTAssert([minus.numberValue isEqual:@(-100)], );
}

- (void)testFloat
{
    SEUnitValue *float_ = [SEUnitValue unitNumberWithValueDescription:@"10.05px"];
    XCTAssert([[float_ numberValue] CGFloatValue] == 10.05f,);
    XCTAssert(float_.unitType == SEUnitTypePixels, );
}

@end
