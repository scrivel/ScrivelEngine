//
//  SETag.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/20.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SETagType){
    SETagTypeLineBreak = 0, // 改行[r]
    SETagTypeWaitInline, // 文章中クリック待ち[l]
    SETagTypeWaitBlock // 改ページクリック待ち[p]
};

@interface SETag : NSObject

- (instancetype)initWithTagName:(NSString*)tagName;

@property NSString *tagName;
@property SETagType tagType;

@end

