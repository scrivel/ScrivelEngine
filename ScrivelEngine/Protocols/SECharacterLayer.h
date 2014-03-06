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
 場所を定義します
 定義された場所はappearメソッドで指定することができます
 
 @method mark
 @param {String|Number} key
 @param {Number} x
 @param {Number} y
 **/
- (void)mark_key:(id<NSCopying>)key x:(CGFloat)x y:(CGFloat)y;

- (void)defineMotion_name:(id<NSCopying>)name;

- (void)endDefine;

@end

@protocol SECharacterLayerInstance <SECharacterLayerInstance>

/**
 表情もしくは別のポーズなどを登録する
 
 @method defineExpression
 @param {String} name 名前
 @param {String} imagePath 画像のパス
 **/
- (void)defineExpression_name:(NSString*)name imagePath:(NSString*)imagePath;

/**
 defineExpressionで登録しておいたエクスプレッションに切り替えます
 
 @method expression
 @param {String} name 切り替わるエクスプレッションの名前
 @param {Number} [duration] クロスフェードする時間
 **/
- (void)expression_name:(NSString*)name duration:(NSTimeinterval)duration;

/**
 キャラクターを退場させます
 
 @method exit
 @param {object} info
     @param {String} info.to 退場する方向。"left" or "right"
     @param {Number} [info.duration] 時間
**/
- (void)exit_to(NSString*)to duration:(NSTimeinterval)duration options:(NSDictionary*)options;

/**
 指定の場所にキャラクターを登場させます
 
 @method appear
 @param {Object} info
     @param {String|Number} info.at 登場する場所。markメソッドで登録されている必要がある
     @param {String} info.from 登場する方向 "left" or "right"
     @param {Number} [info.duration] 時間
 **/
- (void)appear_at:(id<NSCopying>)at from:(NSString*)from duration:(NSTimeinterval)duration;

/**
 
 @method
 **/
- (void)bound_times:(CGFloat)times;
- (void)shake_times:(CGFloat)times;

/**
 
 **/

/**
 レイヤーにモーションを追加します
 
 @param {String} name
 
 **/
- (void)addMotion_name:(NSString*)name;

/**
 キャラクターからモーションを削除します
 
 
 **/
- (void)clearMotion_name:(NSString*)name;

@end
