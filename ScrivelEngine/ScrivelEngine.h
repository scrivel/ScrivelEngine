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

extern NSString *const SEWaitBeganEvent;
extern NSString *const SEWaitCompletionEvent;
extern NSString *const SETimeoutCompletionEvent;
extern NSString *const SETapCompletionEvent;
extern NSString *const SEAnimationCompletionEvent;
extern NSString *const SETextDisplayCompletionEvent;
extern NSString *const SEStateChangedEvent;
extern NSString *const SEStateChangedEventStateKey;

@class Queue, SEScript, SEMethod, SEBasicApp;
@protocol SEClassProxy, SEApp, SELayerClass, SETextLayerClass, SETextLayerDelegate, SECharacterLayerClass;

/**
 ScrivelEngineの本体。
 インスタンス化して使います。
 
 `ScrivelEngine *engine = [ScrivelEngine engineWithWindow:self.window rootView:self.view];`
 **/

/**
 エンジンの状態
 **/
typedef NS_ENUM(NSUInteger, ScrivelEngineState){
    ScrivelEngineStateIdle = 0,
    ScrivelEngineStateRunning,
    ScrivelEngineStatePaused
};

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
/** エンジンの状態 **/
@property (nonatomic, readonly) ScrivelEngineState state;
/** リソースのベースURL **/
@property (nonatomic, copy) NSURL *baseURL;
/** エンジンの実行スピード **/
@property (nonatomic) CGFloat speed;
/** 現在キューイングされているスクリプトのタスク **/
@property (nonatomic, readonly) Queue *taskQueue;
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
/** エンジンの実行を一時的に止めます **/
- (void)pause;
/** エンジンの実行を再生します **/
- (void)resume;
/** エンジンの内部のオブジェクトをすべて削除します **/
- (void)clear;
/** SEScriptを実行 **/
- (id)evaluateScript:(NSString*)script error:(NSError**)error;
/** スクリプトをキューイング **/
- (id)enqueueScript:(SEScript*)script prior:(BOOL)prior;
/** スクリプトをlint **/
- (BOOL)validateScript:(NSString*)script error:(NSError**)error;
/** 秒数をエンジンの実行時間にコンバートする **/
- (CFTimeInterval)convertDuration:(CFTimeInterval)duration;
/** エンジン内のリソースへのパスを取得する **/
- (NSString*)pathForResource:(NSString*)path;

@end