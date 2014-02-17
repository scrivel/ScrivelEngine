//
//  _SELayer.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"

@protocol SELayer <SEObject>
@required

/**
 ScrivelEngineのレイヤーオブジェクト。
 基本的にはUIView/NSViewのラッパー。
 
 @class SELayer
 @extends SEObject
 **/

/**
 
 @method at
 @static
 @param {Number} index レイヤー番号
 @return SELayer
 **/
+ (id)layerAtIndex:(NSUInteger)index;

/**
 レイヤーのアンカーポイントを指定する。
 pointの各値は0~1の間で正規化されている必要がある。
 
 @method anchorPoint
 @param {Number} x
 @param {Number} y
 **/
- (void)setAnchorPoint:(CGPoint)anchorPoint;

/**
 レイヤーの位置のタイプを指定する。
 デフォルトは"px"。左上を原点とした座標系。
 "normalized"が指定された場合、左上を原点とした正規化された座標に変換される。
 
 @method positionType
 @param	{String} type "normalized" or "px"
 **/
typedef enum{
    SEPositionTypePX,
    SEPositionTypeNormalized
}SEPositionType;

- (void)setPositionType:(SEPositionType)positionType;

/**
 レイヤーの位置を指定する。
 位置はanchorによってpxか0~1の値になる
 
 @method  position
 @param	{Number} x
 @param	{Number} y
 @param {Number} [duration]
 **/
- (void)setPosition:(CGPoint)position duration:(NSTimeInterval)duration;

/**
 レイヤーのz座標の位置を指定する。
 
 @method  zPosition
 @param	{Number} z px
 @parma {Number} duration
 **/
- (void)setZPosition:(CGFloat)zPosition duration:(NSTimeInterval)duration;

/**
 レイヤーのサイズを変更する。
 画像が読み込まれていた場合はサイズを優先して拡大縮小する。
 
 @method  size
 @param	{Number} width
 @param	{Number} height
 @param  {Number} [duration]
 **/
- (void)setSize:(CGSize)size duration:(NSTimeInterval)duration;

/**
 レイヤーを表示する。
 すでに表示されている場合は何も起こらない。
 durationを指定することでフェードインする。
 
 @method  show
 @param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
 **/
- (void)show:(NSTimeInterval)duration;

/**
 レイヤーを非表示にする。
 すでに非表示の場合は何も起こらない。
 durationを指定することでフェードアウトする。
 
 @method  hide
 @param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
 **/
- (void)hide:(NSTimeInterval)duration;

/**
 レイヤーの表示/非表示を切り替える。
 
 @method  toggle
 @param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
 **/
- (void)toggle:(NSTimeInterval)duration;

/**
 レイヤーに画像を読み込む。
 sizeが指定されていた場合、
 
 @method  image
 @param	{String} path 読み込む画像のファイル名。[NSBundle mainBundle]からの相対パス。
 @param	{Object} [options]
 @param {Number} [options.duration] クロスフェードさせる場合の秒数
 @param {Object} [options.size] 画像のサイズ。読み込んだ後にレイヤーのsizeを変更する
 **/
- (void)setImage:(NSString*)imagePath options:(NSDictionary*)options;

/**
 レイヤーに読み込んである画像をクリアする。
 画像以外のレイヤー属性はそのまま存在する。
 
 @method  clearImage
 **/
- (void)clearImage;

/**
 レイヤーを破棄する。
 読み込まれている画像、設定されているアニメーションは即時に破棄される。
 
 @method  clear
 **/
- (void)clear;

/**
 後面レイヤーを返す。
 後面レイヤーは各レイヤーにつき1枚あり、前面レイヤーの後ろ側に存在する。
 このメソッドの返り値はflipメソッドでレイヤーを反転させた場合に入れ替わる。
 
 @method backside
 @return SELayer
 **/
- (instancetype)backside;

/**
 レイヤーをフリップさせ、以降SELayer.at()で参照するレイヤーオブジェクトが入れ替わる。
 現在前面のレイヤーはbacksideに格納される。
 backsideメソッドの返り値が変わる。
 
 @method  flip
 @params {String} direction	方向。"vertical"か"horizontal"のみ。
 @param	{Number} duration	秒数
 **/
typedef enum{
    SELayerFlipDirectionLeft = 0,
    SELayerFlipDirectionRight,
    SELayerFlipDirectionTop,
    SELayerFlipDirectionBottom
}SELayerFlipDirection;
- (void)flip:(SELayerFlipDirection)direction duration:(NSTimeInterval)duration;

/**
 レイヤーを移動させる。
 移動はリニアなものに限られる。
 座標系によってx,yの値が正しくなければいけない。
 
 @method  translate
 @param	{Number} x px or 0~1
 @param	{Number} y px or 0~1
 @param	{Number} [duration]	秒数
 **/

- (void)translate:(CGPoint)point duration:(NSTimeInterval)duration;

/**
 レイヤーを現在のアンカーポイントを中心に拡大/縮小する
 
 @method  scale
 @param	{Number} ratio	 	拡大率。1.0=100%
 @param	{Number} [duration]	秒数
 **/
- (void)scale:(CGFloat)ratio duration:(NSTimeInterval)duration;

/**
 レイヤーをanchorPointを中心に回転させる。
 
 @method  rotate
 @param	{Number} degree		角度。
 @param	{Number} [duration]	秒数
 正の値で左回転。負の値で右回転。
 **/
- (void)rotate:(CGFloat)degree duration:(NSTimeInterval)duration;

/**
 レイヤーの不透明度を指定する。
 
 @method  opacity
 @param	{Number} ratio 0~1の値
 @param  {Number} [duration]
 **/
- (void)opacity:(CGFloat)opacity duration:(NSTimeInterval)duration;

/**
 レイヤーをアニメーションさせる。
 複数のアニメーションを合成する。
 各アニメーションに関してはそれぞれのメソッドを参照のこと。
 
 @method animate
 @param	{Object} transition 遷移アニメーション
    @param {Object} [transition.size] サイズ
        @param {Object} [transition.size.width]
        @param {Object} [transition.size.height]
    @param {Number} [transition.scale] 拡大率。0~
    @param {Object} [transition.position] 位置
        @param {Number} [transition.position.x]
        @param {Number} [transition.position.y]
    @param {Number} [transition.opacity] 不透明度。0~1
    @param {Number} [transition.rotation] 回転。degree
    @param	{Number} duration 秒数。ミリセカンド
 **/
- (void)animate:(NSDictionary*)animations duration:(NSTimeInterval)duration;

@end
