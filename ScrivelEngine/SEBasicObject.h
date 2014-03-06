
//
//  _SEConcretObject.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"

OBJC_EXPORT id callMethod(id , NSString *, SEMethod *, ScrivelEngine *);

@interface _SEObject : NSObject <SEObject>

@property (nonatomic, readonly) NSDictionary *keyValueStore;
@property (nonatomic, readonly) NSDictionary *enabledStore;
@property (nonatomic, readonly) NSDictionary *aliasStore;

- (BOOL)respondsToKey:(NSString*)key;
- (BOOL)canEnableForKey:(NSString*)key;
- (BOOL)canAliasizeForKey:(NSString*)key;

@end

@interface SEBasicObjectClass : _SEObject <SEObjectClass>

@property (nonatomic, readonly) ScrivelEngine *engine;
@property (nonatomic, readonly) NSSet *instances;
@property (nonatomic, weak) Class instanceClass;
@property (nonatomic, readonly) NSString *classIdentifier;

- (instancetype)initWithEngine:(ScrivelEngine*)engine classIdentifier:(NSString*)classIdentifier;;

@end

@interface SEBasicObject : _SEObject <SEObjectInstance>

@property (nonatomic, weak) SEBasicObjectClass *holder;

- (instancetype)initWithOpts:(NSDictionary*)options holder:(SEBasicObjectClass*)holder;

@end

