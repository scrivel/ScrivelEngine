//
//  SEClassProxy.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEClassProxy.h"
#import <objc/message.h>

@implementation SEClassProxy

- (id)proxyClassMethod:(SEMethod *)method
{
    @throw @"サブクラスでのオーバーライドが必要!!";
    return nil;
}

- (Class)classForClassIdentifier:(NSString *)classIdentifier
{
    /*
     ScrivelEngineがデフォルトでサポートしているクラス
     layer  =>  SELayer
     bg     =>  SEBackground
     tf     =>  SETextFrame
     ui     =>  SEUserInterface
     bgm    =>  SEBackGroundMusic
     se     =>  SESoundEffect
     */
    if ([classIdentifier isEqualToString:@"layer"]) {
        // レイヤー
    }else if ([classIdentifier isEqualToString:@"bg"]){
        // 背景
    }else if ([classIdentifier isEqualToString:@"tf"]){
        // テクストフレーム
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
