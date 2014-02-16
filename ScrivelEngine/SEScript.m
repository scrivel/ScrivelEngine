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

static NSString *const kSEScriptErrorDomain = @"org.scrive.ScrivelEngine:SEScriptErrorDomain";

@implementation SEScript
{
    NSMutableArray *__elements;
    NSUInteger _currentElementIndex;
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
    _currentElementIndex = 0;
    return self ?: nil;
}

- (void)evaluateNext
{
    _currentElementIndex++;    
    SEElement *next = [__elements objectAtIndex:_currentElementIndex];
    // 現状SEElementはすべてSEMethodChainだが一応
    if ([next isKindOfClass:[SEMethodChain class]]) {
        [(SEMethodChain*)next call];
    }
}

- (void)addElement:(SEElement *)element
{
    [__elements addObject:element];
}

- (NSUInteger)numberOfLines
{
    return [[__elements lastObject] lineNumber];
}

- (SEElement *)currentElement
{
    return [__elements objectAtIndex:_currentElementIndex];
}

@end
