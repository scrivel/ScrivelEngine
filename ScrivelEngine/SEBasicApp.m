//
//  SEBasicApp.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicApp.h"

@implementation SEBasicApp

- (id)init
{
    self = [super init];
    _positionType = SEPositionTypeNormalized;
    _sizeType = SESizeTypePX;
    return self ?: nil;
}

- (void)setPositionType_type:(NSString *)type
{
    NSLog(@"%@",type);
    if ([type isEqualToString:@"norm"]) {
        _positionType = SEPositionTypeNormalized;
    }else if ([type isEqualToString:@"px"]){
        _positionType = SEPositionTypePX;
    }
}

- (void)setSizeType_type:(NSString *)type
{
    if ([type isEqualToString:@"norm"]) {
        _positionType = SEPositionTypeNormalized;
    }else if ([type isEqualToString:@"px"]){
        _positionType = SEPositionTypePX;
    }
}

@end
