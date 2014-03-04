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

#define kPositionTypeKey @"positionType"
#define kSizeTypeKey @"sizeType"

@implementation SEBasicApp
{
    NSMutableDictionary *__keyValueStore;
    NSMutableDictionary *__enabledStore;
    NSMutableDictionary *__aliasStore;
#if TARGET_OS_IPHONE
    UITapGestureRecognizer *_tapGestureRecognizer;
#else
    SEResponderProxy *_responderProxy;
#endif
    
}

- (id)init
{
    self = [super init];
    __keyValueStore = [NSMutableDictionary new];
    __enabledStore = [NSMutableDictionary new];
    __aliasStore = [NSMutableDictionary new];
    [self set_key:kPositionTypeKey value:@"norm"];
    [self set_key:kSizeTypeKey value:@"px"];
    return self ?: nil;
}

- (void)set_key:(NSString *)key value:(id)value
{
    if (key && value != nil && value != [NSNull null]) {
        [__keyValueStore setObject:value forKey:key];
    }
}

- (void)enable_key:(NSString *)key enable:(BOOL)enable
{
    if (key) {
        [__enabledStore setObject:@(enable) forKey:key];
    }
}

- (void)alias_alias:(NSString *)alias method:(NSString *)method
{
    // wa -> waitAnimation
    [__aliasStore setObject:method forKey:alias];
}

- (NSDictionary *)keyValueStore
{
    return __keyValueStore;
}

- (NSDictionary *)enabledStore
{
    return __enabledStore;
}

- (NSDictionary *)aliasStore
{
    return __aliasStore;
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

#pragma mark - Accessor

- (SEPositionType)positionType
{
    NSString *t = [__keyValueStore objectForKey:kPositionTypeKey];
    if ([t isEqualToString:@"norm"]) {
        return SEPositionTypeNormalized;
    }else if ([t isEqualToString:@"px"]){
        return SEPositionTypePX;
    }
    return SEPositionTypeNormalized;
}

- (SESizeType)sizeType
{
    NSString *t = [__keyValueStore objectForKey:kSizeTypeKey];
    if ([t isEqualToString:@"norm"]) {
        return SESizeTypeNormalized;
    }else if ([t isEqualToString:@"px"]){
        return SESizeTypePX;
    }
    return SESizeTypePX;
}

@end
