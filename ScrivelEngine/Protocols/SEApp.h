//
//  SEApp.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"
#import "SEObject.h"

@protocol SEApp <SEObjectClass>

/**
 アプリケーションオブジェクト
 グローバルな設定など扱う
 
 @class app
 @extends abstract
 **/

@required

/**
 対応するKeyの値を設定する
 
 @method set
 @param {String} key
 @param {Value} value
 **/
- (void)set_key:(NSString*)key value:(id)value;

/**
 対応する値をenable/disableする
 
 @method enable
 @param {String} key
 @param {Boolean} enable
 **/
- (void)enable_key:(NSString*)key enable:(BOOL)enable;

@end
