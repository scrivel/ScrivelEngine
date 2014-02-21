//
//  ScrivelEngine.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "ScrivelEngine.h"
#import "SEObject.h"
#import "SEScript.h"
#import "SEBasicLayer.h"
#import "SEBasicTextLayer.h"

@implementation ScrivelEngine

- (BOOL)evaluateScript:(NSString *)script error:(NSError *__autoreleasing *)error
{
    SEScript *s = [SEScript scriptWithString:script error:error];
    if (*error) {
        return NO;
    }
    for (SEMethodChain *chain in s.elements) {
        //　メソッドチェーンを実行
        SEMethod *m = [chain.methods objectAtIndex:0];
        if (m.type == SEMethodTypeCall) {
            // hoge(), wait()などのグローバルメソッドコールはこのクラスで処理
            
        }else if (m.type == SEMethodTypeProperty){
            // layer, bgなどのクラスへの参照の場合
            // 対応するクラスをサブクラスから取得
            NSString *classID = m.name;
            Class<SEObject> class = [self classForClassIdentifier:classID];
            // 最初は静的メソッド
            id<SEObject> instance = [class callStatic_method:m engine:self];
            if (instance) {
                // チェーンを実行
                for (int i = 1; i < chain.methods.count; i++) {
                    m = [chain.methods objectAtIndex:i];
                    [instance callInstance_method:m engine:self];
                }
            }
            
        }
    }
    return YES;
}

- (Class)classForClassIdentifier:(NSString *)classIdentifier
{
    /*
     ScrivelEngineがデフォルトでサポートしているクラス
     layer  =>  SELayer
     bg     =>  SEBackgroundLayer
     chara  =>  SECharacterLayer
     tf     =>  SETextLayer
     ui     =>  SEUserInterface
     bgm    =>  SEBackGroundMusic
     se     =>  SESoundEffect
     */
    if ([classIdentifier isEqualToString:@"layer"]) {
        // レイヤー
        return [SEBasicLayer class];
    }else if ([classIdentifier isEqualToString:@"chara"]){
        // キャラ
    }else if ([classIdentifier isEqualToString:@"bg"]){
        // 背景
    }else if ([classIdentifier isEqualToString:@"text"]){
        // テクストフレーム
        return [SEBasicTextLayer class];
    }else if ([classIdentifier isEqualToString:@"ui"]){
        // UI
    }else if ([classIdentifier isEqualToString:@"bgm"]){
        // BGM
    }else if ([classIdentifier isEqualToString:@"se"]){
        // SE
    }
    return nil;
}

@end
