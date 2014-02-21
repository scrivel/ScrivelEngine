//
//  ScrivelEngine.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class SEMethod;
@protocol SEClassProxy;

@interface ScrivelEngine : NSObject

// レイヤーを管理するrootのview
@property (nonatomic, weak) SEView *rootView;
@property () IMP imp;

// sescriptとScrivelEngineの橋渡しをするクラスを登録する
- (void)registerClassForClassProxy:(Class)proxyClass;
- (Class)classProxyClass;
// SEScriptを実行
- (id)evaluateScript:(NSString*)script error:(NSError**)error;

@end

@protocol SEClassProxy

// クラス名に対するobjc上でのクラスを返す
+ (Class)classForClassIdentifier:(NSString*)classIdentifier;
// クラス名とメソッド名に対するobjc上でのセレクターを返す
+ (SEL)selectorForMethodIdentifier:(NSString*)methodIdentifier;

@end
