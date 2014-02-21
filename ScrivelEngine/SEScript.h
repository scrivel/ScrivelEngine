//
//  SEScript.h
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>
#import "SEMethodChain.h"
#import "SEMethod.h"
#import "Queue.h"

@interface SEScript : NSObject

+ (instancetype)scriptWithString:(NSString*)string error:(NSError**)error;

// スクリプトを構成するエレメント
// 実体はSEMethodChain
@property (nonatomic, readonly) NSMutableArray *elements;

@end
