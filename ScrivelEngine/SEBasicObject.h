
//
//  _SEConcretObject.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEObject.h"

@interface SEBasicObject : NSObject <SEObject>

- (instancetype)initWithOpts:(NSDictionary*)options;

@end
