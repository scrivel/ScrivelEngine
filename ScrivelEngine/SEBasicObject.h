
//
//  _SEConcretObject.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_SEObject.h"

#define KEY_IS(k) [key isEqualToString:k]

OBJC_EXPORT id se_callMethod(id , NSString *, SEMethod *, ScrivelEngine *);

@interface SEBasicObjectClass : _SEObject <SEObjectClass>

@property (nonatomic, readonly) NSSet *instances;
@property (nonatomic, readonly) NSString *classIdentifier;

- (instancetype)initWithEngine:(ScrivelEngine*)engine classIdentifier:(NSString*)classIdentifier;;

@end

@interface SEBasicObject : _SEObject <SEObjectInstance>

@property (nonatomic, weak) SEBasicObjectClass *holder;

- (instancetype)initWithOpts:(NSDictionary*)options holder:(SEBasicObjectClass*)holder;

@end

