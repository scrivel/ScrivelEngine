//
//  SEApp.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"
#import "SEObject.h"


/**
 アプリケーションオブジェクト
 グローバルな設定など扱う
 
 @class app
 @extends abstract
 **/

@protocol SEApp <SEObjectClass>

/**
 外部スクリプトをロードして実行する
 
 @method load
 @param {String} scriptPath
 **/
- (void)load_scriptPath:(NSString*)scriptPath;

@end
