//
//  SEGlobalObject.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEObject.h"

@interface SEGlobalObject : NSObject <SEObject>

+ (instancetype)sharedObject;

@end
