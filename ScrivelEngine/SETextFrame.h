//
//  SETextFrame.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SELayer.h"

@protocol SETextFrame <SELayer>

/**
 ScrivelEngineのテキスト表示エリア。
 基本的にひとつだけ。
 
 @class SETextFrame
 @extends SELayer
 **/

/**
 テクストフレームの文字表示の間隔を指定する
 
 @method interval
 @params {Number} interval 秒数。ミリセカンド
 **/
- (void)interval:(NSTimeInterval)interval;

/**
 
 @method  font
 @return	{}
 @params	{}
 **/


/**
 文字列を表示する。文字列は位置文字ずつintervalの値で表示される。
 
 @method text
 @params {String} text 新規に表示する文字列
 @params {Boolean} [immediately] アニメーションさせずに表示するか否か
 **/
- (void)text:(NSString*)text immediately:(BOOL)immediately;

/**
 名前の表示を変更する。
 
 @method name
 @params {String} name 名前
 **/
- (void)name:(NSString*)name;

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
 **/
#if TARGET_OS_IPHONE
#define EdgeInsets UIEdgeInsets
#elif TARGET_OS_MAC
#define EdgeInests NSEdgeInsets
#endif
- (void)padding:(EdgeInests)insets;

/**
 テクストフレームの縦揃えを指定する
 
 @method  verticalAlign
 @params  {String} verticalAlign "top", "middle", "bottom"のいずれか
 **/
typedef enum{
    SETextFrameVerticalAlignTop = 0,
    SETextFrameVerticalAlignMiddle,
    SETextFrameVerticalAlignBottom
}SETextFrameVerticalAlign;
- (void)verticalAlign:(SETextFrameVerticalAlign)verticalAlign;

/**
 テクストフレームの横揃えを指定する。
 
 @method  horizontalAlign
 @params  {String} horizontalAlign "left", "center", "right", "justified", "natulal"のいずれか
 詳細はNSTextAlignmentを参照
 **/
- (void)horizontalAlign:(NSTextAlignment)horizontalAlign;

@end
