//
//  _SEObject.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEMethod;
@protocol SEObject
/**
 ScrivelEngineのベースオブジェクト

 @class SEObject
 **/

/**
 オブジェクトをインスタンス化する

 @method new
 @static
 @param {Object} options コンストラクタに渡す引数。サブクラスによって違う
**/
+ (instancetype)new_opts:(NSDictionary*)opts;

/**
 クラスメソッドを呼び出す

 @method callStatic
 @static
 @param {Object} method
    @param {String} name
    @param {Array}  [arguments]
 **/
+ (id)callStatic_method:(SEMethod*)method;

/**
 インスタンスメソッドを呼び出す

 @method call
 @param {String} name
 @param {Array}  [arguments]
 **/
- (id)callInstance_method:(SEMethod*)method;

/**
 現在の処理を指定の秒数だけ止める

 @method  wait
 @param {Number} duration 秒数（ミリセカンド）
 **/
- (id)wait_duration:(NSTimeInterval)duration;


@end
