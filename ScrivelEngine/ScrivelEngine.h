//
//  ScrivelEngine.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SETypeDefinition.h"
#import "SEGeometory.h"
#import "Queue.h"

extern NSString *const SEWaitBeganEvent;
extern NSString *const SEWaitCompletionEvent;
extern NSString *const SEAnimationCompletionEvent;
extern NSString *const SETextDisplayCompletionEvent;

@class SEScript, SEMethod, SEBasicApp;
@protocol SEClassProxy, SEApp, SELayerClass, SETextLayerClass, SETextLayerDelegate, SECharacterLayerClass;

@interface ScrivelEngine : NSObject

+ (instancetype)engineWithRootView:(SEView*)rootView;

// レイヤーを管理するrootのview
@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, weak) SEView *rootView;
@property (nonatomic) id<SEClassProxy> classProxy;
@property (nonatomic, readonly) BOOL isWaiting;
@property (nonatomic) CGFloat speed;
@property (nonatomic, readonly) Queue *elementQueue;
@property (nonatomic, readonly) Queue *methodQueue;
// アプリケーション本体
@property (nonatomic, readonly) id<SEApp> app;
@property (nonatomic, readonly) id<SELayerClass> layer;
@property (nonatomic, readonly) id<SETextLayerClass> text;
@property (nonatomic, readonly) id<SECharacterLayerClass> chara;

// SEScriptを実行
- (id)evaluateScript:(NSString*)script error:(NSError**)error;
// スクリプトをキューイング
- (id)enqueueScript:(SEScript*)script prior:(BOOL)prior;
// スクリプトをlint
- (BOOL)validateScript:(NSString*)script error:(NSError**)error;
// 秒数をエンジンの実行時間にコンバートする
- (CFTimeInterval)convertDuration:(CFTimeInterval)duration;

@end