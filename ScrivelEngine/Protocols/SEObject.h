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

@required
/**
 メソッドを呼び出す
 
 @method callMethod
 @param {String} name
 **/
- (id)callMethod_method:(SEMethod*)method;

@optional
/**
 スクリプトの処理を規定の秒数だけストップさせる
 このメソッドはScrielEngineのscript evaluationをサスペンドするメソッドです
 CFRunLoopやNSRunLoopでメインスレッドをブロックする処理は避けてください
 
 @method wait
 @param {Number} duration
 **/
- (void)wait_duration:(NSTimeInterval)duration;

/**
 画面へのタップを待ちます
 タップorクリックされるまでスクリプトのevaluationはサスペンドされます
 
 @method waitTap
 **/
- (void)waitTap;

/**
 次のテクストを表示するためにタップを待ちます
 
 @method waitText
 **/
- (void)waitText;

/**
 現在実行中のすべてアニメーションの終了を待ちます
 repeatアニメーションは除外されます
 
 @method waitAnimation
 **/
- (void)waitAnimation;


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
