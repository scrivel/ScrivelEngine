//
//  SEMethodChain.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"

@class SEMethod;

typedef NS_ENUM(NSUInteger, SEMethodChainType){
    SEMethodChainTypeNormal = 0,
    SEMethodChainTypeCharacterSpecified
};

@interface SEMethodChain : SEElement <NSFastEnumeration>

@property (nonatomic, readonly) NSString *target;
@property (nonatomic, readonly) NSMutableArray *methods;
@property (nonatomic, readonly) SEMethodChainType type;

- (instancetype)initWithTarget:(NSString*)target type:(SEMethodChainType)type;

@end
