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

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"elements": @"elements"};
}

+ (NSValueTransformer*)elementsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SEElement class]];
}

- (NSString *)JSONString
{
    NSDictionary *d = [MTLJSONAdapter JSONDictionaryFromModel:self];
    NSError *e = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:&e];
    if (e) {
        return nil;
    }
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_elements countByEnumeratingWithState:state objects:buffer count:len];
}

@end
