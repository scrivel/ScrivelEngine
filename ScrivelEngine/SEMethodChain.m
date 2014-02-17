//
//  SEMethodChain.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethodChain.h"
#import "SEObject.h"
#import "SEGlobalObject.h"
#import "SEMethod.h"
#import "ScrivelEngine.h"

@implementation SEMethodChain
{
    NSMutableArray *__methods;
    NSUInteger _currentMethodIndex;
}

- (id)init
{
    self = [super init];
    __methods = [NSMutableArray new];
    _currentMethodIndex = -1;
    return self ?: nil;
}

- (id)call
{
    // 最初のクラスメソッドを実行
    SEMethod *m = [self nextMethod];
    id<SEObject> instance = nil;
    SEClassProxy *proxy = [[ScrivelEngine sharedEngine] classProxy];
    if (m.type == SEMethodTypeCall) {
        // グローバルメソッド呼び出し
        instance = [SEGlobalObject call:m];
    }else if(m.type == SEMethodTypeProperty){
        // クラスメソッドコール
        Class<SEObject> class = [proxy classForClassIdentifier:m.name];
        instance  = [class call:m];
    }
    // メソッドチェーンを実行
    while ((m = [self nextMethod]) != nil) {
        [instance call:m];
    }
    return instance;
}

- (SEMethod*)nextMethod
{
    _currentMethodIndex++;
    if (_currentMethodIndex < __methods.count) {
        return [__methods objectAtIndex:_currentMethodIndex];
    }else{
        return nil;
    }
}

- (void)enqueMethod:(SEMethod *)method
{
    [__methods addObject:method];
}

- (void)pushMethod:(SEMethod *)method
{
    [__methods insertObject:method atIndex:0];
}

- (NSArray *)methods
{
    return __methods;
}

- (NSString *)description
{
    return __methods.description;
}

@end
