//
//  SEMethodChain.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"

@class SEMethod;

@interface SEMethodChain : SEElement

// メソッドチェーンを構成するメソッドら
@property (nonatomic, readonly) NSArray *methods;
// 現在のチェーンに追加
- (void)addMethod:(SEMethod*)method;
// メソッドを呼び出し
- (id)call;

@end
