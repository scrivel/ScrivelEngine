//
//  ObjcTests.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/22.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>

@protocol HogeProtocol

@optional
- (void)hoge:(int)hoge fuga:(int)fuga var:(int)var;

@end

@interface ObjcTests : XCTestCase <HogeProtocol>

@end

@implementation ObjcTests

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


- (void)testAssert
{
    // 全部ダメ
    //    NSParameterAssert(0);
    //    NSParameterAssert(0.0);
    //    NSParameterAssert(false);
    //    NSParameterAssert(NO);
    //    NSParameterAssert(nil);
}

- (void)testArgnum
{
    NSUInteger i;
    XCTAssertNoThrow(i = [[self methodSignatureForSelector:@selector(hoge:fuga:var:)] numberOfArguments], );
    XCTAssert(i == 5,); // 2 + 3 = 5
    NSObject *ob = [NSObject new];
    XCTAssertNoThrow(i = [[ob methodSignatureForSelector:@selector(hoge:fuga:var:)] numberOfArguments], );
    XCTAssertFalse(i == 5, ); // 0
}


- (void)testIf
{
    int b = 0;
    if (b < 1) {
        b++;
    }else if (b < 2){
        b++;
    }else if (b < 3){
        b++;
    }
    XCTAssert(b == 1,);
}

- (void)testPath
{
    NSString *path = @"Resources/subdir/file.hoge.png";
    NSString *ext = [path pathExtension];
    NSArray *pc = [path pathComponents];
    
}

@end
