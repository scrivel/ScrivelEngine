//
//  SEScript.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScript.h"
#import "SEScriptAssembler.h"
#import "SEMethod.h"

static NSString *const kSEScriptErrorDomain = @"org.scrive.ScrivelEngine:SEScriptErrorDomain";

@implementation SEScript
{
    NSMutableArray *__elements;
}

+ (instancetype)scriptWithString:(NSString *)string error:(NSError *__autoreleasing *)error
{
    // パーサーをインスタンス化
    SEScriptParser *parser = [SEScriptParser new];
    SEScriptAssembler *assembler = [SEScriptAssembler new];
    // パーシング
    [parser parseString:string assembler:assembler error:error];
    SEScript *script = [assembler assemble];
    return script ?: nil;;
}

- (instancetype)init
{
    self = [super init];
    __elements = [NSMutableArray new];
    return self ?: nil;
}

- (id)run
{
    return nil;
}

- (void)addElement:(SEElement *)element
{
    [__elements addObject:element];
}

@end
