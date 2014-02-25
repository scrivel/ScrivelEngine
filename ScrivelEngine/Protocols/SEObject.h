//
//  _SEObject.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEMethod, ScrivelEngine;
@protocol SEObjectClass, SEObjectInstance;
/**
 ScrivelEngineのベースオブジェクト

 @class Abstract
 **/

@protocol SEObjectClass

/**
 オブジェクトをインスタンス化する

 @method new
 @static
 @param {Object} options コンストラクタに渡す引数。サブクラスによって違う
**/
- (id<SEObjectInstance>)new_args:(id)args;

/**
 クラスメソッドを呼び出す

 @method callStatic
 @static
 @param {Object} method
    @param {String} name
    @param {Array}  [arguments]
 **/
- (id)callStatic_method:(SEMethod*)method;

@end

@protocol SEObjectInstance
/**
 インスタンスメソッドを呼び出す

 @method callInstance
 @param {String} name
 @param {Array}  [arguments]
 **/
- (id)callInstance_method:(SEMethod*)method;


@end
