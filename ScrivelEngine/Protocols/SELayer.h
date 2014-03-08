//
//  _SELayer.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/17.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"
#import "ScrivelEngine.h"

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
 すべてのレイヤーを破棄する
 
 @method clearAll
 **/
- (void)clearAll;

/**
 
 @method define
 **/
- (void)define_name:(id<NSCopying>)name animations:(NSDictionary*)animations options:(NSDictionary*)options;


@end

@protocol SELayerInstance <SEObjectInstance>

#pragma mark - Property

/**
 位置、回転などのアンカーポイント。
 
 @properety anchorPoint
 @type String
 @default (0.5,0.5)
 **/
@property (nonatomic) CGPoint anchorPoint;
/**
 
 @property gravity
 @type String
 **/
@property (nonatomic) NSString *gravity;

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
 
 @property bgColor
 @type String
 **/
@property (nonatomic) SEColor *bgColor;
/**
 境界線の太さ指定する
 
 @property borderWidth
 @type Number
 **/
@property (nonatomic) CGFloat borderWidth;
/**
 境界線の色を指定する
 
 @property borderColor
 @type
 **/
@property (nonatomic) SEColor *borderColor;
/**
 影のオフセットを指定する
 
 @property shadowOffset
 **/
@property (nonatomic) SESize shadowOffset;
/**
 影の色を指定する
 
 @property shadowColor
 **/
@property (nonatomic) SEColor *shadowColor;
/**
 影の不透明度を指定する
 
 @property shadowOpacity
 **/
@property (nonatomic) CGFloat shadowOpacity;
/**
 影の拡散を指定する
 
 @property shadowRadius
 **/
@property (nonatomic) CGFloat shadowRadius;

#pragma mark - Animation

/**
 アニメーションを合成する
 // 1のレイヤーに、3秒で(0.1,0)移動、20度回転、拡大率200%のアニメーションを使用する
 layer.get(1)
    .transact(3, {
        translate : [0.1,0],
        scale : 2.0,
        rotate: 20
    })
 
 @method transact
 @param {Number} duration 秒数
 @param {Object} animations アニメーションの指定
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
- (void)transact_duration:(NSTimeInterval)duration animations:(NSDictionary*)animations options:(NSDictionary*)options;

/**
 アニメーションチェインを開始する。
 ~ commit()までに呼び出されたアニメーションメソッドは逐次実行される
 
 @method chain
 **/
- (void)chain;

/**
 チェインを終了する 
 
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
 レイヤーをアニメーションさせる
 animatebleなkeyは以下
 position x,y
 zPosition z
 size w,h
 translate x, y
 translateZ z
 scale ratio
 rotate degree
 rotateX degree
 rotateY degree
 opacity ratio
 
 @method animate
 @param {String} key
 @param {Number|Object} value
 @param {Number} [duration]
 @param {Object} [options]
 **/
- (void)animate_key:(NSString*)key value:(id)value duration:(CFTimeInterval)duration options:(NSDictionary*)options;
/**
 定義済みのアニメーションを実行する
 
 @method do
 @param {String} animationName
 @param {Number} duration
 **/
- (void)do_animationName:(NSString *)animationName duration:(CFTimeInterval)duration;
@end
