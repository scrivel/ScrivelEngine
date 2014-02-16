/**
ScrivelEngineのレイヤーオブジェクト。
	基本的にはUIView/NSViewのラッパー。
	
@class SELayer
@extends SEObject
**/

/**
レイヤーのアンカーポイントを指定する。
pointの各値は0~1の間で正規化されている必要がある。

@method  anchor
@param {Number} x
@param {Number} y
	
**/

/**
レイヤーの位置を指定する。
位置はanchorによってpxか0~1の値になる

@method  position
@param	{Number} x
@param	{Number} y
**/

/**
レイヤーのサイズを変更する。
画像が読み込まれていた場合はサイズを優先して拡大縮小する。

@method  size
@param	{Number} width
@param	{Number} height
**/

/**
レイヤーを表示する。
すでに表示されている場合は何も起こらない。
durationを指定することでフェードインする。

@method  show
@param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
**/

/**
レイヤーを非表示にする。
すでに非表示の場合は何も起こらない。
durationを指定することでフェードアウトする。

@method  hide
@param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
**/


/**
レイヤーの表示/非表示を切り替える。

@method  toggle
@param	{Number} [duration]	秒数はミリセカンド(1/1000秒）
**/


/**
レイヤーに画像を読み込む。
sizeが指定されていた場合、

@method  image
@param	{String} path 読み込む画像のファイル名。[NSBundle mainBundle]からの相対パス。
@param	{Object} [options]
	@param {Number} [options.duration] クロスフェードさせる場合の秒数
	@param {Object} [options.size] 画像のサイズ。読み込んだ後にレイヤーのsizeを変更する
**/
/**
レイヤーに読み込んである画像をクリアする。
画像以外のレイヤー属性はそのまま存在する。

@method  clearImage
**/
/**
レイヤーを破棄する。
読み込まれている画像、設定されているアニメーションは即時に破棄される。

@method  clear
**/

/**
後面レイヤーを返す。
後面レイヤーは各レイヤーにつき1枚あり、前面レイヤーの後ろ側に存在する。
このメソッドの返り値はflipメソッドでレイヤーを反転させた場合に入れ替わる。

@method backside
@return SELayer
**/

/**
レイヤーをフリップさせ、以降SELayer.at()で参照するレイヤーオブジェクトが入れ替わる。
現在前面のレイヤーはbacksideに格納される。
backsideメソッドの返り値が変わる。

@method  flip
@param	{Number} duration	秒数
@params {String} direction	方向。"vertical"か"horizontal"のみ。
**/


/**
レイヤーを移動させる。
移動はリニアなものに限られる。
座標系によってx,yの値が正しくなければいけない。

@method  translate
@param	{Number} duration	秒数
@param	{Number} x px or 0~1
@param	{Number} y px or 0~1
**/

/**
レイヤーを現在のアンカーポイントを中心に拡大/縮小する

@method  scale
@param	{Number} duration	秒数
@param	{Number} ratio	 	拡大率。1.0=100%
**/

/**
レイヤーを回転させる。

@method  rotate
@param	{Number} duration	秒数
@param	{Number} degree		角度。
	正の値で左回転。負の値で右回転。
**/

/**
レイヤーを揺らす

@method  shake
@param	{Number} count 回数
**/

/**
レイヤーの不透明度を指定する。

@method  opacity
@param	{Number} ratio 0~1の値
**/

/**
レイヤーをアニメーションさせる。
複数のアニメーションを合成する。
各アニメーションに関してはそれぞれのメソッドを参照のこと。

@method animate
@param	{Number} duration 秒数
@param	{Object} transition 遷移アニメーション
	@param {Object} [transition.size] サイズ
		@param {Object} [transition.size.width]
		@param {Object} [transition.size.height]
	@param {Number} [transition.scale] 拡大率
	@param {Object} [transition.position] 位置
		@param {Number} x
		@param {Number} y
	@param {Number} [transition.opacity] 不透明度
	@param {Number} [transitioin.rotation] 回転
**/