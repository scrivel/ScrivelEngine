//
//  SEScript2.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScript2.h"
#import "SEScript2Parser.h"
#import "SEScript2Assembler.h"

@implementation SEScript2

+ (instancetype)scriptWithString:(NSString *)string engine:(ScrivelEngine *)engine error:(NSError *__autoreleasing *)error
{
    // パーサーをインスタンス化
    SEScript2Parser *parser = [SEScript2Parser new];
    SEScript2Assembler *assembler = [[SEScript2Assembler alloc] initWithEngine:engine];
    // パーシング
    [parser parseString:string assembler:assembler error:error];
    SEScript2 *script = [assembler assemble];
    return script ?: nil;;
}

- (instancetype)init
{
    self = [super init];
    _elements = [NSMutableArray new];
    return self ?: nil;
}

@end
