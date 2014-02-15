//
//  SEScript.h
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>
#import "SEScriptParser.h"
#import "PKToken+ScrivelEngine.h"

@interface SEScript : NSObject
<SEScriptAssemblerDelegate>

+ (instancetype)scriptWithString:(NSString*)string error:(NSError**)error;


// スクリプトの総行数
@property (nonatomic, readonly) NSUInteger numberOfLines;
// 現在評価中のスクリプト行
@property (nonatomic, readonly) NSUInteger evaluatingLineNumber;
// スクリプトを開始
- (id)run;

@end
