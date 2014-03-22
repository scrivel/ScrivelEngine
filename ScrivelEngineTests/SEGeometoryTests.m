//
//  SEGeometoryTests.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SEGeometory.h"

@interface SEGeometoryTests : XCTestCase

@end

@implementation SEGeometoryTests

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

- (void)testUnitFloatMake
{
    SEUnitFloat *f = SEUnitFloatMake(@"1");
    XCTAssert(f.numberValue.CGFloatValue == 1.0f, );
    XCTAssert([[SEUnitFloatMake(@10.0) numberValue] CGFloatValue] == 10.0f, );
    XCTAssert([[SEUnitFloatMake(@"15px") numberValue] CGFloatValue] == 15.0f, );
    XCTAssert([[SEUnitFloatMake(@"100%") numberValue] CGFloatValue] == 100.0f, );
}

- (void)testMakeX
{
    CGSize size = CGSizeMake(320, 480);
    XCTAssert(SEMakeX(size.width, SEUnitFloatMake(@"100px")) == 100.0f, );
    XCTAssert(SEMakeX(size.width, SEUnitFloatMake(@"50%")) == 160.0f , );
    XCTAssert(SEMakeX(size.width, SEUnitFloatMake(@10)) == 10.f, );
}

- (void)testMakeY
{
    CGSize size = CGSizeMake(320, 480);
#if TARGET_OS_IPHONE
    XCTAssert(SEMakeY(size.height, SEUnitFloatMake(@"380px")) == 100.0f, );
    XCTAssert(SEMakeY(size.height, SEUnitFloatMake(@"50%")) == 240.0f , );
    XCTAssert(SEMakeY(size.height, SEUnitFloatMake(@470)) == 10.f, );
#else
    XCTAssert(SEMakeY(size.height, SEUnitFloatMake(@"100px")) == 100.0f, );
    XCTAssert(SEMakeY(size.height, SEUnitFloatMake(@"50%")) == 240.0f , );
    XCTAssert(SEMakeY(size.height, SEUnitFloatMake(@10)) == 10.f, );
#endif
}

- (void)testSizeMake
{
    CGSize size = CGSizeMake(320, 480);
    SESize sesize;
    sesize = SESizeMake(size, SEUnitFloatMake(@"100px"), SEUnitFloatMake(@"200px"));
    XCTAssert(CGSizeEqualToSize(sesize, CGSizeMake(100, 200)), );
    sesize = SESizeMake(size, SEUnitFloatMake(@"50%"), SEUnitFloatMake(@"10%"));
    XCTAssert(CGSizeEqualToSize(sesize, CGSizeMake(160.0f, 48.0f)), );    
}

- (void)testPointMake
{
    CGSize size = CGSizeMake(320, 480);
    SEPoint point;
    point = SEPointMake(size, @"100px", @"200px");
#if TARGET_OS_IPHONE
    XCTAssert(CGPointEqualToPoint(point, CGPointMake(100, 280)), );
#elif TARGET_OS_MAC
    XCTAssert(CGPointEqualToPoint(point, CGPointMake(100, 200)), );
#endif
    point = SEPointMake(size, @"50%", @"400px");
#if TARGET_OS_IPHONE
    XCTAssert(CGPointEqualToPoint(point, CGPointMake(160, 80)), );
#elif TARGET_OS_MAC
    XCTAssert(CGPointEqualToPoint(point, CGPointMake(160, 400)), );
#endif
}

@end
