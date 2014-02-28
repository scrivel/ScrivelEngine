//
//  _SEObject.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEMethod, ScrivelEngine;
@protocol SEObjectClass, SEObjectInstance;
/**
 ScrivelEngineのベースオブジェクト

 @class abstract
 **/

@protocol SEObject <NSObject>

/**
 メソッドを呼び出す
 
 @method callMethod
 @param {String} name
 **/
- (id)callMethod_method:(SEMethod*)method;

@end

@protocol SEObjectClass <SEObject>

/**
 オブジェクトをインスタンス化する

 @method new
 @static
 @param {Object} options コンストラクタに渡す引数。サブクラスによって違う
**/
- (id<SEObjectInstance>)new_args:(id)args;

@end

@protocol SEObjectInstance <SEObject>

@end
