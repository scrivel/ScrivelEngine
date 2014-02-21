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
 テクストフレームの文字表示の間隔を指定する
 
 @method interval
 @params {Number} interval 秒数。ミリセカンド
 **/
- (void)set_interval:(NSTimeInterval)interval;

/**
 
 @method  font
 @return	{}
 @params	{}
 **/
- (void)set_font:(NSDictionary*)font;

/**
 文字列を表示する。文字列は位置文字ずつintervalの値で表示される。
 
 @method text
 @params {String} text 新規に表示する文字列
 @params {Boolean} [noanimate] アニメーションさせずに表示するか否か
 **/
- (void)set_text:(NSString*)text noanimate:(BOOL)noanimate;

/**
 名前の表示を変更する。
 
 @method name
 @params {String} name 名前
 **/
- (void)set_name:(NSString*)name;

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
 @params {Object} insets
    @params {Number} [insets.top]
    @params {Number} [insets.left]
    @params {Number} [insets.bottom]
    @params {Number} [insets.right]
 **/
- (void)set_padding:(NSDictionary*)insets;

/**
 テクストフレームの縦揃えを指定する
 
 @method  verticalAlign
 @params  {String} verticalAlign "top", "middle", "bottom"のいずれか
 **/
- (void)set_verticalAlign:(NSString*)verticalAlign;

/**
 テクストフレームの横揃えを指定する。
 
 @method  horizontalAlign
 @params  {String} horizontalAlign "left", "center", "right", "justified", "natulal"のいずれか
 詳細はNSTextAlignmentを参照
 **/
- (void)set_horizontalAlign:(NSTextAlignment)horizontalAlign;

@end
