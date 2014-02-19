//
//  Stack.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/19.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject <NSFastEnumeration>

- (id)pop;
- (void)push:(id)obj;

- (NSUInteger)count;

@end
