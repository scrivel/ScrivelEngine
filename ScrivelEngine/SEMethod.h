//
//  SEScript.h
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEObject;

#define SENilInteger NSIntegerMin
#define SENilDouble CGFLOAT_MIN

typedef enum{
    SEMethodTypeCall = 0,
    SEMethodTypeProperty
}SEMethodType;

@interface SEMethod : NSObject

+ (instancetype)nameMethod;
+ (instancetype)textMethod;

- (instancetype)initWithName:(NSString*)name type:(SEMethodType)type;

// スクリプトの名前
@property (nonatomic, readonly) NSString *name;
// スクリプトのタイプ。メソッド呼び出しか、アクセッサか
@property (nonatomic, readonly) SEMethodType type;
// スクリプトの引数。typeがaccessorの場合はない
@property (nonatomic) NSArray *arguments;

- (id)argAtIndex:(NSUInteger)index;
- (double)doubleArgAtIndex:(NSUInteger)index;
- (NSInteger)integerArgAtIndex:(NSUInteger)index;
- (BOOL)boolArgAtIndex:(NSUInteger)index;

@end
