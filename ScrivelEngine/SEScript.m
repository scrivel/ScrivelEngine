//
//  SEScript.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScript.h"

static NSString *const kSEScriptErrorDomain = @"org.scrive.ScrivelEngine:SEScriptErrorDomain";

@implementation SEScript
{
    NSMutableArray *__methods;
}

+ (instancetype)scriptWithString:(NSString *)string error:(NSError *__autoreleasing *)error
{
    // 返り値
    SEScript *__self = nil;
    // パーサーをインスタンス化
    SEScriptParser *parser = [SEScriptParser new];
    // パーシング
    PKAssembly *result = [parser parseString:string assembler:self error:error];
    
    return __self;
}

- (instancetype)init
{
    self = [super init];
    __methods = [NSMutableArray new];
    return self ?: nil;
}

- (id)run
{
    return nil;
}

#pragma mark - Assembler

- (void)parser:(PKParser *)parser didMatchMethod:(PKAssembly *)assembly
{
    // メソッド
    NSLog(@"%s, %@",__PRETTY_FUNCTION__, assembly);
}

- (void)parser:(PKParser *)parser didMatchWords:(PKAssembly *)assembly
{
    // セリフなど
    NSLog(@"%s, %@",__PRETTY_FUNCTION__, assembly);
}

@end
