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
 コンストラクタ
 
 @method new
 @static
 @param {Object} options
    @param {Number} options.index 作成するレイヤーの番号
 **/
+ (instancetype)new_options:(NSDictionary*)options;

/**
 指定された番号のレイヤーを返す
 指定された番号にレイヤーがない場合はnilを返す
 
 @method at
 @static
 @param {Number} index レイヤー番号
 @return SELayer
 **/
+ (id)at_index:(NSUInteger)index;


/**
 レイヤーのアンカーポイントを指定する。
 pointの各値は0~1の間で正規化されている必要がある。
 
 @method setAnchorPoint
 @param {Number} x
 @param {Number} y
 **/
- (void)setAnchorPoint_x:(CGFloat)x y:(CGFloat)y;

/**
 レイヤーの位置のタイプを指定する。
 デフォルトは"px"。左上を原点とした座標系。
 "normalized"が指定された場合、左上を原点とした正規化された座標に変換される。
 
 @method setPositionType
 @param	{String} type "normalized" or "px"
 **/
- (void)setPositionType_type:(NSString*)type;

/**
 レイヤーの位置を指定する。
 位置はanchorによってpxか0~1の値になる
 
 @method  position
 @param	{Number} x
 @param	{Number} y
 @param {Number} [duration]
 **/
- (void)position_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration;

/**
 レイヤーのz座標の位置を指定する。
 
 @method  zPosition
 @param	{Number} z px
 @parma {Number} duration
 **/
- (void)zPosition_z:(CGFloat)z duration:(NSTimeInterval)duration;

/**
 レイヤーのサイズを変更する。
 画像が読み込まれていた場合はサイズを優先して拡大縮小する。
 
 @method  size
 @param	{Number} width
 @param	{Number} height
 @param  {Number} [duration]
 **/
- (void)size_width:(CGSize)size duration:(NSTimeInterval)duration;

/**
 レイヤーを表示する。
 すでに表示されている場合は何も起こらない。
 durationを指定することでフェードインする。
 
 @method  show
 @param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
 **/
- (void)show_duration:(NSTimeInterval)duration;

/**
 レイヤーを非表示にする。
 すでに非表示の場合は何も起こらない。
 durationを指定することでフェードアウトする。
 
 @method  hide
 @param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
 **/
- (void)hide_duration:(NSTimeInterval)duration;

/**
 レイヤーの表示/非表示を切り替える。
 
 @method  toggle
 @param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
 **/
- (void)toggle_duration:(NSTimeInterval)duration;

/**
 レイヤーに画像を読み込む。
 sizeが指定されていた場合、
 
 @method  setImage
 @param	{String} path 読み込む画像のファイル名。[NSBundle mainBundle]からの相対パス。
 @param	{Object} [options]
 @param {Number} [options.duration] クロスフェードさせる場合の秒数
 @param {Object} [options.size] 画像のサイズ。読み込んだ後にレイヤーのsizeを変更する
 **/
- (void)setImage_path:(NSString*)path options:(NSDictionary*)options;

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
 背景色を指定する
 
 @method bg
 @param {String} color 色 by hex #ffffff
 **/
- (void)bg_color:(NSDictionary*)color;

/**
 境界線を指定する
 
 @method border
     @params {Number} [width] 境界線の幅 by px
     @params {String} [color] 境界線の色 by hex #123456
 **/
- (void)border_width:(CGFloat)width color:(NSString*)color;

/**
 陰を指定する
 
 @method shadow
 @param {Object} options
    @param {String} [options.color] 色 by hex #ffffff
    @param {Object} [options.offset] 方向
        @param {Number} options.offset.x
        @param {Number} options.offset.y
    @param {Number} [options.opacity] 不透明度
    @param {Number} [options.radius] 拡散
 **/
- (void)shadow_options:(NSDictionary*)options;


/**
 レイヤーを移動させる。
 移動はリニアなものに限られる。
 座標系によってx,yの値が正しくなければいけない。
 
 @method  translate
 @param	{Number} x px or 0~1
 @param	{Number} y px or 0~1
 @param {Number} z px
 @param	{Number} [duration]	秒数
 **/

- (void)translate_x:(CGFloat)x y:(CGFloat)y z:(CGFloat)z duration:(NSTimeInterval)duration;

/**
 レイヤーを現在のアンカーポイントを中心に拡大/縮小する
 
 @method  scale
 @param	{Number} ratio	 	拡大率。1.0=100%
 @param	{Number} [duration]	秒数
 **/
- (void)scale_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration;

/**
 レイヤーをanchorPointを中心に回転させる。
 
 @method  rotate
 @param	{Number} degree		角度。
 @param	{Number} [duration]	秒数
 正の値で左回転。負の値で右回転。
 **/
- (void)rotate_degree:(CGFloat)degree duration:(NSTimeInterval)duration;

/**
 レイヤーの不透明度を指定する。
 
 @method  opacity
 @param	{Number} ratio 0~1の値
 @param  {Number} [duration]
 **/
- (void)opacity_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration;

/**
 レイヤーをアニメーションさせる。
 複数のアニメーションを合成する。
 各アニメーションに関してはそれぞれのメソッドを参照のこと。
 
 @method animate
 @param	{Object} animations 遷移アニメーション
    @param {Object} [transition.size] サイズ
        @param {Object} [transition.size.width]
        @param {Object} [transition.size.height]
    @param {Number} [transition.scale] 拡大率。0~
    @param {Object} [transition.position] 位置
        @param {Number} [transition.position.x]
        @param {Number} [transition.position.y]
    @param {Number} [transition.zPosition] z方向の位置
    @param {Object} [transition.translate] 移動
        @param {Number} [transition.translate.x] x
        @param {Number} [transition.translate.y] y
        @param {Number} [transition.translate.z] z
    @param {Number} [transition.opacity] 不透明度。0~1
    @param {Number} [transition.rotation] 回転。degree
    @param {Number] [transition.hidden] 表示
@param	{Number} duration 秒数。ミリセカンド
 **/
- (void)animate_animations:(NSDictionary*)animations duration:(NSTimeInterval)duration;

@end
