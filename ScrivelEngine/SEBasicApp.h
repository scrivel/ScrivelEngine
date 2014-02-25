//
//  SEBasicApp.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicObject.h"
#import "SEApp.h"

@interface SEBasicApp : SEBasicObjectClass <SEApp>

@property (nonatomic) SEPositionType positionType;
@property (nonatomic) SESizeType sizeType;

@end
