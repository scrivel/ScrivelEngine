//
//  SEHTML.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/20.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SEHTMLTagType){
    SEHTMLTagTypeParagraph,
    SEHTMLTagTypeBold,
    SEHTMLTagTypeItalic,
    SEHTMLTagTypeUnderline
};

@interface SEHTML : NSObject

@property (nonatomic) id content;
@property (nonatomic) NSString *tagName;
@property (nonatomic) SEHTMLTagType htmlTagType;
@property (nonatomic) NSDictionary *attributes;

- (instancetype)initWithTagName:(NSString*)tagName;

@end
