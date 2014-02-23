//
//  SETextFrame.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SELayer.h"

@protocol SETextLayer <SELayer>

/**
 ScrivelEngineのテキスト表示エリア。
 基本的にひとつだけ。
 
 @class text
 @extends layer
 **/


/**
 文字表示の間隔を指定する
 
 @method interval
 @param {Number} interval 秒数。デフォルトは0.1。
 **/
- (void)setInterval_interval:(NSTimeInterval)interval;

/**
 フォントを指定する
 
 @method font
 @param {String} name
 @param {Number} size
 **/
- (void)setFont_name:(NSString*)name size:(CGFloat)size;

/**
 行間を指定する
 
 @method lineSpacing
 @param {Number} spacing
 **/
- (void)setLineSpacing_spacing:(CGFloat)spacing;

/**
 文字列を表示する。文字列は位置文字ずつintervalの値で表示される。
 
 @method text
 @param {String} text 新規に表示する文字列
 @param {Boolean} [noanimate] アニメーションさせずに表示するか否か
 **/
- (void)setText_text:(NSString*)text noanimate:(BOOL)noanimate;

/**
 現在表示している文字列をクリアする
 @method  clear
 **/
- (void)clear;

/**
 現在のアニメーションを止めて文字をすべて表示する
 
 @method skip
 **/
- (void)skip;

/**
 レイヤーサイズに対してのテクストエリアのパディングを設定する
 
 @method padding
 @param {Number} top
 @param {Number} left
 @param {Number} bottom
 @param {Number} right
 **/
- (void)setPadding_top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

/**
 テクストフレームの縦揃えを指定する
 
 @method  verticalAlign
 @param  {String} verticalAlign "top", "middle", "bottom"のいずれか
 **/

- (void)setVerticalAlign_direction:(NSString*)direction;

/**
 テクストフレームの横揃えを指定する。
 
 @method  horizontalAlign
 @param  {String} horizontalAlign "left", "center", "right", "justified", "natulal"のいずれか
 詳細はNSTextAlignmentを参照
 **/
- (void)setHorizontalAlign_direction:(NSTextAlignment)direction;

@end
