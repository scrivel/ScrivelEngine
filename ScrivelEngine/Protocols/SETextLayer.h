//
//  SETextFrame.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SELayer.h"

@protocol SETextLayerClass <SELayerClass>


/**
 プライマリテキストレイヤーのindexを指定する
 デフォルトでは最初にインスタンス化されたSETextLayerInstanceがprimaryに設定される
 以降、クラスに対するインスタンスメソッドの呼び出しは、対象のindexに対して行われる
 text.new(1)
 text.text("some text") // <-> text.at(1).text("some text")
 
 @method setPrimary
 @static
 @pram {Number} index レイヤーの番号
 **/
- (void)setPrimary_key:(id<NSCopying>)key;


/**
 名前を表示するためのプライマリレイヤーの番号を指定する
 
 @method setNameLayer
 @static
 @param {Number} index レイヤーの番号
 **/
- (void)setNameLayer_key:(id<NSCopying>)key;

/**
 現在のプライマリネームレイヤーに名前を表示する
 プライマリネームレイヤーが存在しない場合はなにもしない
 
 @method setName
 @param {String} name 名前
 **/
- (void)setName_name:(NSString*)name;

@end

@protocol SETextLayerInstance <SELayerInstance>

/**
 ScrivelEngineのテキスト表示エリア。
 
 @class text
 @extends layer
 **/


/**
 文字表示の間隔を指定する
 
 @method setInterval
 @param {Number} interval 秒数。デフォルトは0.1。
 **/
- (void)setInterval_interval:(NSTimeInterval)interval;

/**
 フォントを指定する
 
 @method setFont
 @param {String} name
 @param {Number} size
 **/
- (void)setFont_name:(NSString*)name size:(CGFloat)size;

/**
 文字色を指定する
 
 @method setCcolor
 @param {String} color by hex
 **/
- (void)setColor_color:(NSString*)color;

/**
 行間を指定する
 
 @method setLineSpacing
 @param {Number} spacing
 **/
- (void)setLineSpacing_spacing:(CGFloat)spacing;

/**
 文字列を表示する。文字列は一文字ずつintervalの値で表示される。
 noanimateをtrueに設定した場合、startが呼ばれるまで表示はしない。
 
 @method setText
 @param {String} text 新規に表示する文字列
 @param {Boolean} [noanimate] アニメーションさせずに表示するか否か
 **/
- (void)setText_text:(NSString*)text noanimate:(BOOL)noanimate;

/**
 文字列の表示を開始する
 
 @method start
 **/
- (void)start;

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