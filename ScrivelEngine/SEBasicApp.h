//
//  SEBasicApp.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicObject.h"
#import "SEApp.h"

extern NSString *const SEWaitStateKey;
extern NSString *const SETapCompletionEventLocationKey;

typedef NS_ENUM(NSUInteger, SEWaitingState){
    SEWaitingStateNone = 0,
    SEWaitingStateTimeout,
    SEWaitingStateTap,
    SEWaitingStateAnimation,
    SEWaitingStateText
};
@interface SEBasicApp : SEBasicObjectClass <SEApp>

@property (nonatomic, readonly) SEWaitingState waitingState;

- (void)setUpTapRecognizerWithView:(SEView*)view;

@end
