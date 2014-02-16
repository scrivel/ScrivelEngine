//
//  SEClassProxy.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEClassProxy.h"

@implementation SEClassProxy

- (id)proxyClassMethod:(SEMethod *)method
{
    NSAssert(NO,@"サブクラスでのオーバーライドが必要!!");
    return nil;
}

@end
