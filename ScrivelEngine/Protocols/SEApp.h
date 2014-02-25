//
//  SEApp.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"
#import "SEObject.h"

@protocol SEApp <SEObjectClass>

/**
 アプリケーションオブジェクト
 グローバルな設定など扱う
 
 @class App
 @extends Abstract
 **/

@required

/**
 エンジンの中での位置のタイプを指定する。
 デフォルトは"norm"。0~1のrootViewに対する正規化された値。
 
 @method setPositionType
 @param	{String} type "norm" or "px"
 **/
- (void)setPositionType_type:(NSString*)type;

/**
 
 @method positioinType
 **/
- (SEPositionType)positionType;

/**
 エンジンの中でのサイズタイプを指定する。
 デフォルトは"px"。
 
 @method setSizeType
 @param {String} type "norm" or "px"
  **/
- (void)setSizeType_type:(NSString*)type;

/**
 
 @method sizeType
 **/
- (SESizeType)sizeType;

@end
