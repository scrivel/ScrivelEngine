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
    PKTokenizer *t = [PKTokenizer tokenizerWithString:string];
    PKToken *eof = [PKToken EOFToken];
    PKToken *tok = [t nextToken];
    
    // スクリプトは - から始まる。
//    if (![tok isHyphen]) {
//        return [self raiseError:error type:SEScriptParseErrorUnexpectedToken token:tok];
//    }
    
    // クラスを特定
    if (tok.tokenType != PKTokenTypeWord){
        return [self raiseError:error type:SEScriptParseErrorObjectNotSpecified token:tok];
    }
    // bg => SEBackground, layer => SELayer ...
    NSString *targetName = [tok stringValue];
    SEObject *target = nil;
    SEScript *script = nil;
    tok = [t nextToken];
    if ([tok isStartOfMethod]) {
        // - hoge()のようなトップレベル関数呼び出しはglobalオブジェクトをターゲットにしてリカーシブコールする
        return [self scriptWithString:[@"global." stringByAppendingString:string] error:error];
    }else if([tok isDotChain]){
        // - bg.transition()のようなオブジェクトへのメソッド呼び出し
        target = [SEObject staticObjectNamed:targetName];
        if (!target) {
            return [self raiseError:error type:SEScriptParseErrorObjectNotFound token:tok];
        }
        script = [[SEScript alloc] initWithTarget:target];
    }else{
        // "- bg"のようなオブジェクトのみの呼び出し
        return [self raiseError:error type:SEScriptParseErrorMethodNotCalled token:tok];
    }
    // parse開始
    while ((tok = [t nextToken]) != eof) {
        NSLog(@"(%@) (%.1f) : %@", tok.stringValue, tok.floatValue, [tok debugDescription]);
        // 文字列のはず
        if (tok.tokenType == PKTokenTypeWord) {
            // 名前を取得
            NSString *name = [tok stringValue];
            // 次のトークンへ
            tok = [t nextToken];
            if ([tok isStartOfMethod]){
                NSMutableArray *args = @[].mutableCopy;
                PKToken *tok = nil;
                while (![(tok = [t nextToken]) isEndOfMethod]) {
                    if ([tok isCommna]) {
                        tok = [t nextToken];
                    }
                    if ([tok isNumber] || [tok isQuotedString]) {
                        [args addObject:tok.value];
                    }else{
                        return [self raiseError:error type:SEScriptParseErrorUnexpectedToken token:tok];
                    }
                }
                SEMethod *s =  [[SEMethod alloc] initWithName:name type:SEScriptTypeMethodCall];
                [s setArguments:args];
                [script addMethod:s];
                // 一つ進める
                tok = [t nextToken];
                // )の次がeofか.じゃない場合は落とす
                if (![tok isDotChain] && tok != eof) {
                    return [self raiseError:error type:SEScriptParseErrorUnexpectedToken token:tok];
                }
            }else if([tok isDotChain]){
                // 次が"."or eofならアクセッサ
                SEMethod *s = [[SEMethod alloc] initWithName:name type:SEScriptTypeAccessor];
                [script addMethod:s];
                continue;
            }else if(tok == eof){
                // obj.path.to.call().keyのような最終的にメソッドが呼ばれていないパターン
                return [self raiseError:error type:SEScriptParseErrorMethodNotCalled token:tok];
            }else{
                return [self raiseError:error type:SEScriptParseErrorUnexpectedToken token:tok];
            }
            // スクリプトに追加
        }else{
            return [self raiseError:error type:SEScriptParseErrorUnexpectedToken token:tok];
        }
    }
    return script;
}

+ (id)raiseError:(NSError**)error type:(SEScriptParseError)type token:(PKToken*)token
{
    NSString *desc = @"";
    switch (type) {
        case SEScriptParseErrorUnexpectedToken:
            desc  = @"文法が間違っています";
            break;
        case SEScriptParseErrorObjectNotSpecified:
            desc = @"オブジェクトが指定されていません";
            break;
        case SEScriptParseErrorObjectNotFound:
            desc = @"オブジェクトが見つかりません";
            break;
        default:
            desc = @"不明なエラー";
            break;
    }
    NSDictionary *d = @{NSLocalizedDescriptionKey: [desc stringByAppendingFormat:@" -> %@", token.stringValue] };
    *error = [NSError errorWithDomain:kSEScriptErrorDomain code:type userInfo:d];
    return nil;
}

- (instancetype)initWithTarget:(SEObject *)target
{
    self = [super init];
    _target = target;
    __methods = [NSMutableArray new];
    return self ?: nil;
}

- (void)addMethod:(SEMethod *)method
{
    [__methods addObject:method];
}

- (void)removeMethod:(SEMethod *)method
{
    [__methods removeObject:method];
}

- (NSArray *)methods
{
    return [NSArray arrayWithArray:__methods];
}

- (id)run
{
    return nil;
}

@end
