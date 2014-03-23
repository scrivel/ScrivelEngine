//
//  SEScript.h
//  PetiteCouturiere
//
//  Created by keroxp on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>
#import <Mantle/Mantle.h>
#import "SEMethodChain.h"
#import "SEMethod.h"
#import "Queue.h"

@interface SEScript : MTLModel <NSFastEnumeration, MTLJSONSerializing>

+ (instancetype)scriptWithString:(NSString*)string error:(NSError**)error;

// スクリプトを構成するエレメント
// 実体はSEMethodChain
@property (nonatomic, readonly) NSMutableArray *elements;

- (NSString*)JSONString;

@end
