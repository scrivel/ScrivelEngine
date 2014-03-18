//
//  SEUnitNumberTests.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEUnitFloat.h"
#import "NSNumber+CGFloat.h"

@interface SEUnitFloatTests : XCTestCase

@end

@implementation SEUnitFloatTests

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
    SEUnitFloat *px = [SEUnitFloat unitNumberWithValueDescription:@"10px"];
    XCTAssert([px.numberValue isEqual:@10], );
    XCTAssert(px.unitType == SEUnitTypePixels, );
    SEUnitFloat *percent = [SEUnitFloat unitNumberWithValueDescription:@"10%"];
    XCTAssert(percent.unitType == SEUnitTypePercentage, );
    XCTAssert([percent.numberValue isEqual:@10], );
    SEUnitFloat *vpx = [SEUnitFloat unitNumberWithValueDescription:@"10vpx"];
    XCTAssert([vpx.numberValue isEqual:@10], );
    XCTAssert(vpx.unitType == SEUnitTypeVirtualPixels, );
    SEUnitFloat *normal = [SEUnitFloat unitNumberWithValueDescription:@"10"];
    XCTAssert([normal.numberValue isEqual:@10], );
    XCTAssert(normal.unitType == SEUnitTypeDefault, );
    SEUnitFloat *minus = [SEUnitFloat unitNumberWithValueDescription:@"-100px"];
    XCTAssert([minus.numberValue isEqual:@(-100)], );
}

- (void)testFloat
{
    SEUnitFloat *float_ = [SEUnitFloat unitNumberWithValueDescription:@"10.05px"];
    XCTAssert([[float_ numberValue] CGFloatValue] == 10.05f,);
    XCTAssert(float_.unitType == SEUnitTypePixels, );
}

@end
