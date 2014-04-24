//
//  SEScript2.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"

@interface SEScript2 : NSObject

+ (instancetype)scriptWithString:(NSString*)string engine:(ScrivelEngine*)engine error:(NSError**)error;
@property (nonatomic, readonly) NSMutableArray *elements;

@end
