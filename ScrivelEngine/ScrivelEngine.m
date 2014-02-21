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

- (id)evaluateScript:(NSString *)script error:(NSError *__autoreleasing *)error
{
    SEScript *s = [SEScript scriptWithString:script error:error];
    id returnValue = nil;
    if (*error) {
        return NO;
    }
    for (id element in s.elements) {
        if ([element isKindOfClass:[SEMethodChain class]]) {
            //　メソッドチェーンを実行
            SEMethodChain *chain = (SEMethodChain*)element;
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
                    returnValue = instance;
                    for (int i = 1; i < chain.methods.count; i++) {
                        m = [chain.methods objectAtIndex:i];
                        returnValue = [instance callInstance_method:m engine:self];
                    }
                }
                
            }
        }else{
            // value
            return element;
        }
    }
    return returnValue;
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
