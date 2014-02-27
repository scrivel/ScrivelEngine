//
//  SEWords.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEWords.h"

@implementation SEWords

- (instancetype)initWithName:(NSString *)name text:(NSString *)text
{
    self = [self init];
    _name = name;
    _text = text;
    return self ?:nil;
}

@end
