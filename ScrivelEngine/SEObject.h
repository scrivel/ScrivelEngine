//
//  _SEObject.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEMethod;
@protocol SEObject <NSObject>
/**
 ScrivelEngineのベースオブジェクト
 
 @class SEObject
 **/

/**
 クラスメソッドを呼び出す
 
 @method call
 @static
 @param {Object} method
    @param {String} name
    @param {Array}  [arguments]
 **/
+ (id)call:(SEMethod*)method;

/**
 インスタンスメソッドを呼び出す
 
 @method call
 @param {String} name
 @param {Array}  [arguments]
 **/
- (id)call:(SEMethod*)method;

/**
 現在の処理を指定の秒数だけ止める
 
 @method  wait
 @param {Number} duration 秒数（ミリセカンド）
 **/
- (id)wait:(NSTimeInterval)duration;


@end
