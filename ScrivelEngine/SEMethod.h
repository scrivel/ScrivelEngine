//
//  SEScript.h
//  PetiteCouturiere
//
//  Created by keroxp on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"

@class SEObject;

@interface SEMethod : NSObject

- (instancetype)initWithName:(NSString*)name lineNumer:(NSUInteger)lineNumber;

@property (nonatomic) id<SEObject> target;
// スクリプトの名前
@property (nonatomic, readonly) NSString *name;
// 行番号
@property (nonatomic, readonly) NSUInteger lineNumber;
// スクリプトの引数。typeがaccessorの場合はない
@property (nonatomic) NSArray *arguments;

- (id)argAtIndex:(NSUInteger)index;
- (CGFloat)CGFloatArgAtIndex:(NSUInteger)index;
- (NSUInteger)unsignedIntegerArtAtIndex:(NSUInteger)index;
- (NSInteger)integerArgAtIndex:(NSUInteger)index;
- (double)doubleArgAtIndex:(NSUInteger)index;
- (BOOL)boolArgAtIndex:(NSUInteger)index;

- (id)call;
- (id)callWithTarget:(id<SEObject>)target;

@end
