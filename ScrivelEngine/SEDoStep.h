//
//  SEDoStep.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEStep.h"

@interface SEDoStep : SEStep

- (instancetype)initWithName:(NSString*)name arguments:(NSDictionary*)arguments;

@property (nonatomic) NSString *name;
@property (nonatomic) NSDictionary *arguments;

@end
