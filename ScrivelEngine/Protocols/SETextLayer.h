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
 テキストアニメーションの間隔

 @type Number
 @default 0.1
 @property interval
 **/
@property (nonatomic) CFTimeInterval interval;
/**
 フォント
 
 @type String
 @property fontName
 **/
@property (nonatomic) NSString *fontName;
/**
 フォントサイズ
 
 @type Number
 @property fontSize
 **/
@property (nonatomic) CGFloat fontSize;
/**
 フォントカラー
 
 @type String
 @property color
 **/
@property (nonatomic) SEColor *color;
/**
 行間の幅
 
 @property lineSpacing
 **/
@property (nonatomic) CGFloat lineSpacing;
/**
 背景に対するpadding
 
 @property padding
 **/
@property (nonatomic) SEEdgeInsets padding;
/**
 文字寄せ
 
 @property textAlign
 **/
@property (nonatomic) SETextAlignment textAlign;

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

@end