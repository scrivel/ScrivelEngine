//
//  ScrivelEngineTests.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ScrivelEngine.h"
#import "SEObject.h"
#import "SELayer.h"
#import "SEBasicClassProxy.h"

#define NEWENGINE [ScrivelEngine new]
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
    id ret;
    NSError *e = nil;
    XCTAssertNoThrow(ret = [NEWENGINE evaluateScript:@"layer.get(1).animate(\"position\",[100,100]);" error:&e], );
    XCTAssertNil(e, );
    NSLog(@"%@",e);
}

- (void)testString
{
    NSError *e;
    id obj = [NEWENGINE evaluateScript:@"\"string\";" error:&e];
    XCTAssert([obj isKindOfClass:[NSString class]], @"文字列が帰ってきている");
    XCTAssert([obj isEqualToString:@"string"], @"string");
}

- (void)testNumber
{
    NSError *e;
    id obj = [NEWENGINE evaluateScript:@"24;" error:&e];
    XCTAssertNil(e, );
    XCTAssert([obj isKindOfClass:[NSNumber class]], @"NSNumber");
    XCTAssert([obj integerValue] == 24, @"24");
    obj = [NEWENGINE evaluateScript:@"24.14;" error:&e];
    XCTAssertNil(e, );
    XCTAssert([obj isKindOfClass:[NSNumber class]],);
    XCTAssert([obj doubleValue] > 24,);
    obj = [NEWENGINE evaluateScript:@"-23.3;" error:&e];
    XCTAssert([obj isKindOfClass:[NSNumber class]],);
    XCTAssert([obj doubleValue] < -23.0,);
}

- (void)testArray
{
    NSError *e;
    id obj = [NEWENGINE evaluateScript:@"[1,2,3.1,-0.9];" error:&e];
    XCTAssertNil(e, );
    XCTAssert([obj isKindOfClass:[NSArray class]],);
    XCTAssertFalse([obj isKindOfClass:[NSMutableArray class]], @"mutableではない");
    XCTAssert([obj count] == 4,);
    XCTAssert([[obj firstObject] integerValue] == 1,);
    XCTAssert([[obj lastObject] doubleValue] == (double)-0.9,);
    for (id num in obj) {
        XCTAssert([num isKindOfClass:[NSNumber class]],);
    }
}
- (void)testArray2
{
    NSError *e;
    id obj = [NEWENGINE evaluateScript:@"[1,2,3,[4,5,6]];" error:&e];
    XCTAssertNil(e, );
    XCTAssert([obj isKindOfClass:[NSArray class]],);
    XCTAssertFalse([obj isKindOfClass:[NSMutableArray class]], @"mutableではない");
    XCTAssert([obj count] == 4,);
    XCTAssert([[obj lastObject] isKindOfClass:[NSArray class]], );
}

- (void)testObject
{
    NSError *e;
    NSString *json = @"{\
    key : \"value\",\
    numKey : 1, \
    numKey2 : 2.0, \
    arrKey : [\
        \"hoge\",\
        1,\
        -12,\
        {\
            nestedKey : \"nestedValue\" ,\
            nestedObj : {\
                deep : 1\
            }\
        }\
    ]\
    };";
    NSDictionary *obj = [NEWENGINE evaluateScript:json error:&e];
    if (e) {
        NSLog(@"%@",e);
    }
    XCTAssert([obj isKindOfClass:[NSDictionary class]],);
    XCTAssert([[obj allKeys] count] == 4, );
    XCTAssert([[obj objectForKey:@"key"] isEqualToString:@"value"],);
    XCTAssert([[obj objectForKey:@"numKey"] integerValue] == 1,);
    XCTAssert([[obj objectForKey:@"numKey2"] doubleValue] == (double)2.0, );
    XCTAssert([[obj objectForKey:@"arrKey"] isKindOfClass:[NSArray class]],);
    XCTAssert([obj[@"arrKey"][3][@"nestedKey"] isEqualToString:@"nestedValue"],);
    XCTAssert([obj[@"arrKey"][3][@"nestedObj"][@"deep"] integerValue] == 1,);
}

- (void)testClassProxy
{
    id c = [NEWENGINE classProxy];
    XCTAssert([c isKindOfClass:[SEBasicClassProxy class]],);
    SEL sel;
    XCTAssertNoThrow(sel = [c selectorForMethodIdentifier:@"get" classIdentifier:@"layer"], );
    XCTAssert(sel == @selector(get_key:),);
}

//- (void)testConvert
//{
//    ScrivelEngine *engine = NEWENGINE;
//    engine.speed = 2.0f;
//    XCTAssert([engine convertDuration:4.0f] == 2.0f, );
//    engine.speed = ScrivelEngineSppedNoWait;
//    XCTAssert([engine convertDuration:1000.0f] == 0,  );
//}

- (void)testScriptEvaluation
{
    NSArray *scriptPaths = [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:@"sescript" inDirectory:@"Scripts.bundle"];
    for (NSString *path in scriptPaths) {
        @autoreleasepool {
            NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            ScrivelEngine *engine = [ScrivelEngine engineWithWindow:nil rootView:[SEView new]];
            engine.speed = ScrivelEngineSppedNoWait;
            NSError *e = nil;
            XCTAssertNoThrow([engine evaluateScript:script error:&e], );
        }
    }
}

- (void)testResourcePath
{
    /** 
     Users
        keroxp
            hoge
                aaa.jpg
            fuga
                bbb.jpg
     **/
    ScrivelEngine *e = NEWENGINE;
    e.baseURL = [NSURL URLWithString:@"/Users/keroxp/hoge/"];
    XCTAssert([[e pathForResource:@"aaa.jpg"] isEqualToString:@"/Users/keroxp/hoge/aaa.jpg"], );
    XCTAssert([[e pathForResource:@"../fuga/bbb.jpg"] isEqualToString:@"/Users/keroxp/fuga/bbb.jpg"],);
}

@end
