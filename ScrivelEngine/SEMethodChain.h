//
//  SEMethodChain.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"
#import "Queue.h"

@class SEMethod;

@interface SEMethodChain : SEElement

// メソッドチェーンを構成するメソッドら
@property (nonatomic, readonly) NSMutableArray *methods;

@end
