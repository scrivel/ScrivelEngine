//
//  SEBasicApp.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicApp.h"
#import "ScrivelEngine.h"
#if SE_TARGET_OS_MAC
#import "SEResponderProxy.h"
#endif
#import <objc/runtime.h>
#import "NSObject+KXEventEmitter.h"
#import "SEBasicClassProxy.h"
#import "NSBundle+ScrivelEngine.h"
#import "SEScript.h"
#import "NSObject+PerformBlock.h"

NSString *const SEWaitStateKey = @"org.scrivel.ScrivelEngine:SEWaitBeganEventStateKey";
NSString *const SETapCompletionEventLocationKey = @"org.scrivel.ScrivelEngine:SETapCompletionEventLocationKey";

@interface SEBasicApp()

@property (nonatomic, readwrite) SEWaitingState waitingState;

@end

@implementation SEBasicApp
{

#if TARGET_OS_IPHONE
    UITapGestureRecognizer *_tapGestureRecognizer;
#else
    SEResponderProxy *_responderProxy;
#endif
    
}

- (id)init
{
    self = [super init];
    _waitingState = SEWaitingStateNone;
    return self ?: nil;
}

- (void)setUpTapRecognizerWithView:(SEView *)view
{
#if TARGET_OS_IPHONE
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [view addGestureRecognizer:_tapGestureRecognizer];
#else
    _responderProxy = [[SEResponderProxy alloc] initWithDelegate:self selector:@selector(handleTap:)];
    NSResponder *r = view.nextResponder;
    [view setNextResponder:_responderProxy];
    [_responderProxy setNextResponder:r];
#endif
}

- (void)setWaitingState:(SEWaitingState)waitingState
{
    if (_waitingState != waitingState) {
        if (waitingState != SEWaitingStateNone) {
            NSString *event = nil;
            switch (waitingState) {
                case SEWaitingStateTimeout:
                    event = SETimeoutCompletionEvent; break;
                case SEWaitingStateTap:
                    event = SETapCompletionEvent; break;
                case SEWaitingStateAnimation:
                    event = SEAnimationCompletionEvent; break;
                case SEWaitingStateText:
                    event = SETextDisplayCompletionEvent; break;
                default: break;
            }
            if (event) {
                [self kx_once:event handler:^(NSNotification *n) {
                    self.waitingState = SEWaitingStateNone;
                    [self kx_emit:SEWaitCompletionEvent
                         userInfo:@{SEWaitStateKey: @(self.waitingState)}
                           center:self.engine.notificationCenter];
                } from:nil center:self.engine.notificationCenter];
            }
            [self kx_emit:SEWaitBeganEvent
                 userInfo:@{SEWaitStateKey: @(waitingState)}
                   center:self.engine.notificationCenter];
        }
        _waitingState = waitingState;
    }
}

- (void)set_key:(NSString *)key value:(id)value
{
    if (KEY_IS(@"speed")) {
        // エンジンのスピードを設定する
        [self.engine setSpeed:[value doubleValue]];
    }else{
        [super set_key:key value:value];
    }
}

#pragma mark - wait

- (void)wait_duration:(NSTimeInterval)duration
{
    self.waitingState = SEWaitingStateTimeout;
    [self performBlock:^{
        [self kx_emit:SETimeoutCompletionEvent userInfo:nil center:self.engine.notificationCenter];
    } afterDelay:duration];
}

- (void)waitTap
{
    self.waitingState = SEWaitingStateTap;
}

- (void)waitAnimation
{
    self.waitingState = SEWaitingStateAnimation;
}

- (void)waitText
{
    self.waitingState = SEWaitingStateText;
}

#if TARGET_OS_IPHONE
- (void)handleTap:(UITapGestureRecognizer*)sender
{
    SEPoint p = [sender locationInView:self.engine.rootView];
    NSLog(@"tapped : %@",NSStringFromCGPoint(p));
#elif TARGET_OS_MAC
- (void)handleTap:(NSEvent*)sender
{
    SEPoint p = [sender locationInWindow];
    NSLog(@"tapped : %@",NSStringFromPoint(p));
#endif
    [self kx_emit:SETapCompletionEvent
         userInfo:@{SETapCompletionEventLocationKey: [NSValue se_valueWithPoint:p]}
           center:self.engine.notificationCenter];
}

- (void)load_scriptPath:(NSString *)scriptPath
{
    NSString *path = [[NSBundle mainBundle] se_pathForResource:scriptPath];
    if (path) {
        NSError *e = nil;
        NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
        if ([self.engine validateScript:script error:&e]) {
            SEScript *s = [SEScript scriptWithString:script error:&e];
            if (!e) {
                [self.engine enqueueScript:s prior:YES];
            }
        }
    }
}

@end
