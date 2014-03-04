//
//  SEBasicApp.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicObject.h"
#import "SEApp.h"

@interface SEBasicApp : SEBasicObjectClass <SEApp>

@property (nonatomic, readonly) NSDictionary *keyValueStore;
@property (nonatomic, readonly) NSDictionary *enabledStore;
@property (nonatomic, readonly) NSDictionary *aliasStore;

@property (nonatomic, readonly) SEPositionType positionType;
@property (nonatomic, readonly) SESizeType sizeType;

@end
