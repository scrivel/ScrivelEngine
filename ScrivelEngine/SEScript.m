//
//  SEScript.m
//  PetiteCouturiere
//
//  Created by keroxp on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEScript.h"
#import "SEScriptParser.h"
#import "SEScriptAssembler.h"
#import "Stack.h"

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

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_elements countByEnumeratingWithState:state objects:buffer count:len];
}

@end
