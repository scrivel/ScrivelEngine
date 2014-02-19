//
//  SEScript.m
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScript.h"
#import "SEScriptParser.h"
#import "SEScriptAssembler.h"

static NSString *const kSEScriptErrorDomain = @"org.scrivel.ScrivelEngine:SEScriptErrorDomain";

@implementation SEScript

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
    _elements = [NSMutableArray new];
    return self ?: nil;
}

@end
