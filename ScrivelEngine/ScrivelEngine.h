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
extern NSString *const SETimeoutCompletionEvent;
extern NSString *const SETapCompletionEvent;
extern NSString *const SEAnimationCompletionEvent;
extern NSString *const SETextDisplayCompletionEvent;

@class SEScript, SEMethod, SEBasicApp;
@protocol SEClassProxy, SEApp, SELayerClass, SETextLayerClass, SETextLayerDelegate, SECharacterLayerClass;

/**
 ScrivelEngineの本体。
 インスタンス化して使います。
 
 `ScrivelEngine *engine = [ScrivelEngine engineWithWindow:self.window rootView:self.view];`
 **/

@interface ScrivelEngine : NSObject

/**
 エンジンのファクトリメソッド。
 これを使わなくてもあとでwindowとrootViewを設定することができます。
 
 @param window rootView
 @param rootView rootWindow
 **/
+ (instancetype)engineWithWindow:(SEWindow*)window rootView:(SEView*)rootView;

/** レイヤーを管理するrootのview **/
@property (nonatomic, readonly) NSString *identifier;
/** エンジンが実行されるウィンドウ **/
@property (nonatomic, weak) SEWindow *window;
/** アニメーションが実行されるNS/UIView **/
@property (nonatomic, weak) SEView *rootView;
/** SEScriptを実行するためのマッピングオブジェクト **/
@property (nonatomic) id<SEClassProxy> classProxy;
/** エンジンが現在wait状態にあるかどうか **/
@property (nonatomic, readonly) BOOL isWaiting;
/** エンジンの実行スピード **/
@property (nonatomic) CGFloat speed;
/** **/
@property (nonatomic, readonly) Queue *elementQueue;
@property (nonatomic, readonly) Queue *methodQueue;
/** エンジンが内部的に使用するNSNotificationCenterオブジェクト **/
@property (nonatomic, readonly) NSNotificationCenter *notificationCenter;
/** アプリケーションクラスオブジェクト **/
@property (nonatomic, readonly) id<SEApp> app;
/** レイヤークラスオブジェクト **/
@property (nonatomic, readonly) id<SELayerClass> layer;
/** テクストクラスオブジェクト **/
@property (nonatomic, readonly) id<SETextLayerClass> text;
/** キャラクタークラスオブジェクト **/
@property (nonatomic, readonly) id<SECharacterLayerClass> chara;
/** SEScriptを実行 **/
- (id)evaluateScript:(NSString*)script error:(NSError**)error;
/** スクリプトをキューイング **/
- (id)enqueueScript:(SEScript*)script prior:(BOOL)prior;
/** スクリプトをlint **/
- (BOOL)validateScript:(NSString*)script error:(NSError**)error;
/** 秒数をエンジンの実行時間にコンバートする **/
- (CFTimeInterval)convertDuration:(CFTimeInterval)duration;

@end