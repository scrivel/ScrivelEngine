//
//  NSArray+Where.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/21.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Where)

- (NSArray*)whereUsingSelector:(SEL)selector value:(id)value;
- (NSArray*)whereForKeyPath:(NSString*)keyPath comparingSelector:(SEL)selector value:(id)value;

@end