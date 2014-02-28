//
//  SEResponderProxy.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/26.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//


#import "SEResponderProxy.h"
#import <objc/message.h>

@implementation SEResponderProxy

- (instancetype)initWithHandler:(SEBasicTextLayerResponderHandler)hander
{
    self = [self init];
    self.eventandler = hander;
    return self ?: nil;
}

- (instancetype)initWithDelegate:(id)delegate selector:(SEL)selector
{
    self = [self init];
    self.delegate = delegate;
    self.selector = selector;
    return self ?: nil;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.eventandler) {
        self.eventandler(theEvent);
    }else if (self.delegate && self.selector) {
        if ([self.delegate respondsToSelector:self.selector]) {
            objc_msgSend(self.delegate, self.selector, theEvent);
        }
    }
}

@end
