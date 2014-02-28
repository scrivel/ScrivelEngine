//
//  SEResponderProxy.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/26.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//


#import <Cocoa/Cocoa.h>

// レスポンダチェーンをプロクシするクラス

typedef void (^SEBasicTextLayerResponderHandler)(NSEvent *e);

@interface SEResponderProxy : NSResponder

- (instancetype)initWithHandler:(SEBasicTextLayerResponderHandler)hander;
- (instancetype)initWithDelegate:(id)delegate selector:(SEL)selector;

@property (nonatomic, weak) id delegate;
@property (nonatomic) SEL selector;
@property (nonatomic, copy) SEBasicTextLayerResponderHandler eventandler;

@end
