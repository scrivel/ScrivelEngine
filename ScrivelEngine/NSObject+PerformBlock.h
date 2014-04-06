//
//  NSObject+PerformBlock.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/06.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PerformBlock)

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)afterDelay;

@end
