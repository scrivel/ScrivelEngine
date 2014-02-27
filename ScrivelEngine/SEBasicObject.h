
//
//  _SEConcretObject.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"

@interface SEBasicObjectClass : NSObject <SEObjectClass>

@property (nonatomic, readonly) ScrivelEngine *engine;
@property (nonatomic, readonly) NSSet *instances;
@property (nonatomic, weak) Class instanceClass;
@property (nonatomic, readonly) NSString *classIdentifier;

- (instancetype)initWithEngine:(ScrivelEngine*)engine classIdentifier:(NSString*)classIdentifier;;

@end

@interface SEBasicObject : NSObject <SEObjectInstance>

@property (nonatomic, weak) SEBasicObjectClass *holder;

- (instancetype)initWithOpts:(NSDictionary*)options holder:(SEBasicObjectClass*)holder;

@end

