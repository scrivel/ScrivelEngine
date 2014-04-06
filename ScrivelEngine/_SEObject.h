//
//  _SEObject.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/05.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"
#import "ScrivelEngine.h"

@interface _SEObject : NSObject <SEObject>

@property (weak, nonatomic) ScrivelEngine *engine;
@property (nonatomic, readonly) NSDictionary *keyValueStore;
@property (nonatomic, readonly) NSDictionary *enabledStore;
@property (nonatomic, readonly) NSDictionary *aliasStore;

- (BOOL)respondsToKey:(NSString*)key;
- (BOOL)canEnableForKey:(NSString*)key;
- (BOOL)canAliasizeForKey:(NSString*)key;

- (instancetype)initWithEngine:(ScrivelEngine*)engine;

@end
