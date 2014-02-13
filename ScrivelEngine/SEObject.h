//
//  SEObject.h
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEMethod;

/*
 Scrivel Engineとゲーム本体をBridgeするオブジェクトのアブストラクトクラス
 */

@interface SEObject : NSObject

// クラスのインスタンスが特定のメソッドを持っているか
+ (BOOL)instancesRespondToMethod:(SEMethod*)method;
// 静的オブジェクトのアクセス
+ (instancetype)staticObjectNamed:(NSString*)name;
// メソッドを呼び出す
- (id)invokeMethod:(SEMethod*)method;
- (instancetype)initWithName:(NSString*)name;

@property (nonatomic, readonly) NSString *name;

@end
