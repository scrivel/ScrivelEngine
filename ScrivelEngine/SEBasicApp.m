//
//  SEBasicApp.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicApp.h"
#import "ScrivelEngine.h"
#if !TARGET_OS_IPHONE
#import "SEResponderProxy.h"
#endif
#import <objc/runtime.h>
#import "NSObject+KXEventEmitter.h"
#import "SEBasicClassProxy.h"
#import "NSBundle+ScrivelEngine.h"
#import "SEScript.h"

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
    return self ?: nil;
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

- (void)completeWait:(id)sender
{
#if TARGET_OS_IPHONE
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        [self.engine.rootView removeGestureRecognizer:sender];
    }
#else
    if ([sender isKindOfClass:[NSEvent class]]) {
        _responderProxy.delegate = nil;
    }
#endif
    [self kx_emit:SEWaitCompletionEvent];
}

- (void)wait_duration:(NSTimeInterval)duration
{
    [self kx_emit:SEWaitBeganEvent];
    [self performSelector:@selector(completeWait:) withObject:self afterDelay:duration];
}

- (void)waitTap
{
#if TARGET_OS_IPHONE
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeWait:)];
    [self.engine.rootView addGestureRecognizer:tgr];
#else
    if (!_responderProxy) {
        _responderProxy = [[SEResponderProxy alloc] initWithDelegate:nil selector:@selector(completeWait:)];
        NSResponder *r = self.engine.rootView.nextResponder;
        [self.engine.rootView setNextResponder:_responderProxy];
        [_responderProxy setNextResponder:r];
    }
    _responderProxy.delegate = self;
#endif
    [self kx_emit:SEWaitBeganEvent];
}

- (void)waitAnimation
{
    [self kx_emit:SEWaitBeganEvent];
    [self kx_once:SEAnimationCompletionEvent handler:^(NSNotification *n) {
        [self kx_emit:SEWaitCompletionEvent];
    }];
}

- (void)waitText
{

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
