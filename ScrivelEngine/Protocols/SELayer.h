//
//  _SELayer.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"

@protocol SELayerClass <SEObjectClass>
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
 @param {Number} index レイヤーの番号
 **/
- (id<SEObjectInstance>)new_args:(id)args;

#pragma mark - Static

/**
 レイヤーを取得する
 
 @method get
 @static
 @param {String|Number} key レイヤー番号
 **/
- (id)get_key:(id<NSCopying>)key;

/**
 レイヤーを破棄する。
 読み込まれている画像、設定されているアニメーションは即時に破棄される。
 
 @method  clear
 @param {String|Number} key キー
 **/
- (void)clear_key:(id<NSCopying>)key;

/**
 
 @method defineAnimation
 **/
- (void)define_name:(id<NSCopying>)name animations:(NSDictionary*)animations options:(NSDictionary*)options;


@end

@protocol SELayerInstance <SEObjectInstance>

#pragma mark - Property

/**
 レイヤーのアンカーポイントを指定する。
 pointの各値は0~1の間で正規化されている必要がある。
 
 @method setAnchorPoint
 @param {Number} x
 @param {Number} y
 **/
- (void)setAnchorPoint_x:(CGFloat)x y:(CGFloat)y;

/**
 画像のgravity（表示モード）を指定する。
 
 @method setGravity
 @param {String} type
 **/
- (void)setGravity_gravity:(NSString*)gravity;

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
 
 @param {Number} [duration]
 **/
- (void)clearImage_duration:(NSTimeInterval)duration;

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
 
 optionsにはアニメーションの指定もできる
 
 @method begin
 @param {Number} [duration]
 @param {Object} [options] アニメーションオプション
    @param {Boolean} [options.autoreverses] アニメーションを逆実行するか
    @param {Number} [options.repeatCount] アニメーションの繰り返し回数
    @param {Number} [options.repeatDuration] アニメーションの繰り返しの間隔
    @param {Number} [options.timeOffset] アニメーション開始までのオフセット時間
    @param {Boolean} [options.removeOnCompletion] アニメーション終了時にもとに戻すかどうか
    @param {String} [options.timing] アニメーションカーブ // linear, ease-in, ease-out, ease-in-ease-out, default
    @param {Array} [options.timingPoints] アニメーションカーブを構成するポイント。正規化された値。 例) 0.1, 0.1, 0.2, 0.2
    @param {Number} [options.duration] アニメーションの時間。指定された場合こちらが優先される
 **/
- (void)begin_duration:(NSTimeInterval)duration options:(NSDictionary*)options;

/**
 アニメーションチェインを開始する。
 ~ commiAnimation()までに呼び出されたアニメーションメソッドは逐次実行される
 
 @method chain
 **/
- (void)chain;

/**
 アニメーションを開始する
 beginAnimation()からここまでに呼び出されたアニメーションメソッドが合成される
 
 @method commit
 **/
- (void)commit;

/**
 実行中のすべてのアニメーションを削除する
 
 @method stop
 **/
- (void)stop;

/**
 実行中のすべてのアニメーションを一時停止する
 
 @method pause
 **/
- (void)pause;

/**
 一時停止中のアニメーションを再開する
 
 @method resume
 **/
- (void)resume;

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
 **/
- (void)show;

/**
 レイヤーを非表示にする。
 すでに非表示の場合は何も起こらない。
 
 @method  hide
 **/
- (void)hide;

/**
 レイヤーの表示/非表示を切り替える。
 
 @method  toggle
 @param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
 **/
- (void)toggle;

/**
 レイヤーをフェードインさせる
 
 @method fadeIn
 @param {Number} duration
 **/
- (void)fadeIn_duration:(NSTimeInterval)duration;
/**
 レイヤーをフェードアウトさせる
 
 @method fadeOut
 @param {Number} duration
 **/
- (void)fadeOut_duration:(NSTimeInterval)duration;

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
 レイヤーをanchorPointを中心にz軸に対して回転させる。
 
 @method  rotate
 @param	{Number} degree		角度。
 @param	{Number} [duration]	秒数
 正の値で左回転。負の値で右回転。
 **/
- (void)rotate_degree:(CGFloat)degree duration:(NSTimeInterval)duration;

/**
 レイヤーをanchorPointを中心にx軸にたいして回転させる。
 
 @method  rotateX
 @param	{Number} degree		角度。
 @param	{Number} [duration]	秒数
 正の値で左回転。負の値で右回転。
 **/
- (void)rotateX_degree:(CGFloat)degree duration:(NSTimeInterval)duration;

/**
 レイヤーをanchorPointを中心にy軸に対して回転させる。
 
 @method  rotateY
 @param	{Number} degree		角度。
 @param	{Number} [duration]	秒数
 正の値で左回転。負の値で右回転。
 **/
- (void)rotateY_degree:(CGFloat)degree duration:(NSTimeInterval)duration;


/**
 レイヤーの不透明度を指定する。
 
 @method  opacity
 @param	{Number} ratio 0~1の値
 @param  {Number} [duration]
 **/
- (void)opacity_ratio:(CGFloat)ratio duration:(NSTimeInterval)duration;



@end
