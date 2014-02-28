//
//  SEWords.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"

@interface SEWords : SEElement

- (instancetype)initWithName:(NSString*)name text:(NSString*)text;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *text;

@end
