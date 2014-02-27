//
//  SEClassProxy.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/21.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"
#import "SEClassProxy.h"

/*
 SEScriptとScrivelEngineをブリッジするデフォルトのクラス
 */

@class SEMethod;
@interface SEBasicClassProxy : NSObject <SEClassProxy>

@end
