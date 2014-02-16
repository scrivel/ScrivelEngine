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
// チェーンの最後に追加
- (void)enqueMethod:(SEMethod*)method;
// チェーンの先頭に追加
- (void)pushMethod:(SEMethod*)method;

// メソッドを呼び出し
- (id)call;

@end
