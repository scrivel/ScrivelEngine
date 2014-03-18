//
//  SECharacterLayer.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/05.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SELayer.h"

@protocol SECharacterLayerClass <SELayerClass>

/**
 キャラクターを表すクラス
 
 @class chara
 @extends layer
 **/

/**
 場所を定義します
 定義された場所はappearメソッドで指定することができます
 
 @method mark
 @param {String|Number} key
 @param {Number} x
 @param {Number} y
 **/
- (void)mark_key:(id<NSCopying>)key point:(id)point;

/**
 
 @method defineMotion
 @param {String} name
 **/
- (void)defineMotion_name:(NSString*)name;

@end

@protocol SECharacterLayerInstance <SELayerInstance>

/**
 表情もしくは別のポーズなどを登録する
 
 @method defineExpression
 @param {String} name 名前
 @param {String} imagePath 画像のパス
 **/
- (void)defineExpression_name:(NSString*)name imagePath:(NSString*)imagePath;

/**
 defineExpressionで登録しておいたエクスプレッションに切り替えます
 
 @method express
 @param {String} name 切り替わるエクスプレッションの名前
 @param {Number} [duration] クロスフェードする時間
 **/
- (void)express_name:(NSString*)name duration:(NSTimeInterval)duration;

/**
 キャラクターを退場させます
 
 @method exit
 @param {object} info
     @param {String} [info.to] 退場する方向。"left" or "right" or "top" or "bottom"
     @param {Number} [info.duration] 時間
**/
- (void)exit_info:(NSDictionary*)info;

/**
 指定の場所にキャラクターを登場させます
 
 @method appear
 @param {Object} info
     @param {String|Number} info.at 登場する場所。markメソッドで登録されている必要がある
     @param {String} info.from 登場する方向 "left" or "right" or "top" or "bottom"
     @param {Number} [info.duration] 時間
 **/
- (void)appear_info:(NSDictionary*)info;


/**
 キャラクターにモーションを実行させます
 デフォルトで実行可能なモーションは以下です
 @motion jump
 @motion shake
 @motion
 
 
 @method motion
 @param {String}  name
 @param {Object} options
    @param {Number} [options.times] 実行する回数
    @param {Number} [options.duration] 秒数
    @param {String} [options.strength] 強さ。veryLow, low, middle, high, veryHighのいずれか
 **/
- (void)motion_name:(NSString*)name options:(NSDictionary*)options;

@end
