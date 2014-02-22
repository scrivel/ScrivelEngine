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
 基本的にはCALayerのラッパー。
 
 @class layer
 @extends abstract
 **/

#pragma mark - SEObject

/**
 コンストラクタ
 
 @method new
 @static
 @return instancetype
 @param {Object} options
    @param {Number} options.index 作成するレイヤーの番号
 **/
+ (instancetype)new_options:(NSDictionary*)options;

#pragma mark - Static

/**
 指定された番号のレイヤーを返す
 指定された番号にレイヤーがない場合はnilを返す
 
 @method at
 @static
 @return id
 @param {Number} index レイヤー番号
 @return SELayer
 **/
+ (id)at_index:(unsigned int)index;


#pragma mark - Property

/**
 レイヤーのアンカーポイントを指定する。
 pointの各値は0~1の間で正規化されている必要がある。
 
 @method setAnchorPoint
 @param {Number} x
 @param {Number} y
 **/
- (void)set_anchorPoint_x:(CGFloat)x y:(CGFloat)y;

/**
 レイヤーの位置のタイプを指定する。
 デフォルトは"px"。左上を原点とした座標系。
 "normalized"が指定された場合、左上を原点とした正規化された座標に変換される。
 
 @method setPositionType
 @param	{String} type "normalized" or "px"
 **/
- (void)set_positionType_type:(NSString*)type;

#pragma mark - Image

/**
 レイヤーに画像を読み込む。
 sizeが指定されていた場合、
 
 @method  loadImage
 @param	{String} path 読み込む画像のファイル名。[NSBundle mainBundle]からの相対パス。
 @param {Number} [duration] クロスフェードさせる場合の秒数
 **/
- (void)loadImage_path:(NSString*)path duration:(NSTimeInterval)duration;

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

#pragma mark - Appearance

/**
 背景色を指定する
 
 @method bg
 @param {String} color 色 by hex #ffffff
 **/
- (void)bg_color:(NSString*)color;

/**
 境界線を指定する
 
 @method border
     @params {Number} [width] 境界線の幅 by px
     @params {String} [color] 境界線の色 by hex #123456
 **/
- (void)border_width:(CGFloat)width color:(NSString*)color;

/**
 影のオフセットを指定する
 
 @method shadowOffset
 @param {Number} x
 @param {Number} y
 **/
- (void)shadowOffset_x:(CGFloat)x y:(CGFloat)y;
/**
 影の色を指定する
 
 @method shadowColor
 @param {String} color hex
 **/
- (void)shadowColor_color:(NSString*)color;
/**
 影の不透明度を指定する
 
 @method shadowOpacity
 @param {Number} opacity
 **/
- (void)shadowOpcity_opacity:(CGFloat)opacity;

/**
 影の拡散を指定する
 
 @method shadowRadius
 @param {Number} radius
 **/
- (void)shadowRadius_radius:(CGFloat)radius;

#pragma mark - Animation

/**
 アニメーションを生成する
 commitAnimation()までに呼び出されたアニメーションメソッドは合成される
 間で呼び出されたアニメーションメソッドのduration引数は無視される
 // 1番のレイヤーに、3秒で(100,100)移動、20度回転、拡大率200%のアニメーションを使用する
 layer.at(1)
    .beginAnimation(300)
    .translate(100,100)
    .rotate(20)
    .opacity(0.2,100) // 100は無視される
    .scale(2.0)
    .commitAnimation()
 
 
 @method beginAnimation
 @param (Number) [duration]
 **/
- (void)beginAnimation_duration:(NSTimeInterval)duration;

/**
 アニメーションを開始する
 beginAnimation()からここまでに呼び出されたアニメーションメソッドが合成される
 
 @method commitAnimation
 **/
- (void)commitAnimation;

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
- (void)size_width:(CGFloat)width height:(CGFloat)height duration:(NSTimeInterval)duration;

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
 レイヤーを移動させる。
 移動は現在のpositionに加算される。
 
 @method translate
 @param {Number} x
 @param {Number} y
 @param {Number} [duration]
 **/
- (void)translate_x:(CGFloat)x y:(CGFloat)y duration:(NSTimeInterval)duration;

/**
 レイヤーをz方向に移動させる。
 移動は現在のpositionに加算される。
 
 @method translateZ
 @param {Number} z
 @param {Number} [duration]
 **/
- (void)translateZ_z:(CGFloat)z duration:(NSTimeInterval)duration;


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



@end
