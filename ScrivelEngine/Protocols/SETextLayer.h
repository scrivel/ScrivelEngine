//
//  SETextFrame.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SELayer.h"

@protocol SETextLayerClass <SELayerClass>

@end

@protocol SETextLayerInstance <SELayerInstance>

/**
 ScrivelEngineのテキスト表示エリア。
 基本的にひとつだけ。
 
 @class Text
 @extends Layer
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
 文字列を表示する。文字列は一文字ずつintervalの値で表示される。
 noanimateをtrueに設定した場合、startが呼ばれるまで表示はしない。
 
 @method text
 @param {String} text 新規に表示する文字列
 @param {Boolean} [noanimate] アニメーションさせずに表示するか否か
 **/
- (void)text_text:(NSString*)text noanimate:(BOOL)noanimate;

/**
 文字列の表示を開始する
 
 @method start
 **/
- (void)start;

/**
 文字列の表示を一時停止する
 
 @method pause
 **/
- (void)pause;

/**
 一時停止中のアニメーションを再開する
 
 @method resume
 **/
- (void)resume;

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
 テクストフレームの横揃えを指定する。
 
 @method  horizontalAlign
 @param  {String} horizontalAlign "left", "center", "right", "justified", "natulal"のいずれか
 詳細はNSTextAlignmentを参照
 **/
- (void)setHorizontalAlign_direction:(NSTextAlignment)direction;

@end
