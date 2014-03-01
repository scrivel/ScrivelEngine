//
//  SEBasicApp.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicApp.h"
#import "ScrivelEngine.h"
#import "SEResponderProxy.h"
#import <objc/runtime.h>

#define kPositionTypeKey @"positionType"
#define kSizeTypeKey @"sizeType"

@implementation SEBasicApp
{
    NSMutableDictionary *__keyValueStore;
    NSMutableDictionary *__enabledStore;
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

#pragma mark - wait

- (void)completeWait:(id)sender
{
#if TARGET_OS_IPHONE
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        [self.engine.rootView removeGestureRecognizer:sender];
    }
#else
    if ([sender isKindOfClass:[SEResponderProxy class]]) {
        _responderProxy.delegate = nil;
    }
#endif
    if ([sender isKindOfClass:[NSNotification class]]) {
        if ([[(NSNotification*)sender name] isEqualToString:SEAnimationCompletionEvent]) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:SEAnimationCompletionEvent object:nil];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SEWaitCompletionEvent object:sender userInfo:nil];
}

- (void)wait_duration:(NSTimeInterval)duration
{
    [self performSelector:@selector(completeWait:) withObject:self afterDelay:duration];
}

- (void)waitTap
{
#if TARGET_OS_IPHONE
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(completeWait:)];
    [self.engine.rootView addGestureRecognizer:tgr];
#else
    if (!_responderProxy) {
        _responderProxy = [[SEResponderProxy alloc] initWithDelegate:self selector:@selector(completeWait:)];
        NSResponder *r = self.engine.rootView.nextResponder;
        [self.engine.rootView setNextResponder:_responderProxy];
        [_responderProxy setNextResponder:r];
    }
#endif
}

- (void)waitAnimation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeWait:) name:SEAnimationCompletionEvent object:nil];
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
