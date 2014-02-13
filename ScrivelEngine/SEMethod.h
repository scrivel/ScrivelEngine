//
//  SEScript.h
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SEObject;

typedef enum{
    SEScriptTypeMethodCall = 0,
    SEScriptTypeAccessor
}SEScriptType;

@interface SEMethod : NSObject

- (instancetype)initWithName:(NSString*)name type:(SEScriptType)type;

// スクリプトの名前
@property (nonatomic, readonly) NSString *name;
// スクリプトのタイプ。メソッド呼び出しか、アクセッサか
@property (nonatomic, readonly) SEScriptType type;
// スクリプトの引数。typeがaccessorの場合はない
@property (nonatomic) NSArray *arguments;

@end
