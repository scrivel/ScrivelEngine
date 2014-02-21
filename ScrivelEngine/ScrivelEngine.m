//
//  ScrivelEngine.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "ScrivelEngine.h"
#import <objc/message.h>
#import "SEObject.h"
#import "SEScript.h"
#import "SEBasicClassProxy.h"

@implementation ScrivelEngine
{
    Class _classProxyClass;
}

- (id)evaluateScript:(NSString *)script error:(NSError *__autoreleasing *)error
{
    SEScript *s = [SEScript scriptWithString:script error:error];
    id returnValue = nil;
    if (*error) {
        return NO;
    }
    for (id element in s.elements) {
        if ([element isKindOfClass:[SEMethodChain class]]) {
            //　メソッドチェーンを実行
            SEMethodChain *chain = (SEMethodChain*)element;
            SEMethod *m = [chain.methods objectAtIndex:0];
            if (m.type == SEMethodTypeCall) {
                // hoge(), wait()などのグローバルメソッドコールはこのクラスで処理
                
            }else if (m.type == SEMethodTypeProperty){
                // layer, bgなどのクラスへの参照の場合
                // 対応するクラスをサブクラスから取得
                NSString *classID = m.name;
                Class<SEObject> class = [_classProxyClass classForClassIdentifier:classID];
                // 最初は静的メソッド
                id<SEObject> instance = [class callStatic_method:m engine:self];
                if (instance) {
                    // チェーンを実行
                    returnValue = instance;
                    for (int i = 1; i < chain.methods.count; i++) {
                        m = [chain.methods objectAtIndex:i];
                        returnValue = [instance callInstance_method:m engine:self];
                    }
                }
                
            }
        }else{
            // value
            return element;
        }
    }
    return returnValue;
}

- (void)registerClassForClassProxy:(Class)proxyClass
{
    if (!objc_msgSend(proxyClass, @selector(conformsToProtocol:), @protocol(SEClassProxy))) {
        @throw @"このクラスはSEClassProxyプロトコルに準拠していません";
    }
    _classProxyClass = proxyClass;
}

- (Class)classProxyClass
{
    if (!_classProxyClass) {
        // 登録されていなければデフォルトのクラスを返す
        _classProxyClass = [SEBasicClassProxy class];
    }
    return _classProxyClass;
}

@end
