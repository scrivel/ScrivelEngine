//
//  SEMethodChain.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"

@class SEMethod;

@interface SEMethodChain : SEElement <NSFastEnumeration>

@property (nonatomic, readonly) NSString *targetClass;
@property (nonatomic, readonly) NSMutableArray *methods;
@property (nonatomic) NSRange rangeOfLines;

- (instancetype)initWithTargetClass:(NSString*)targetClass;
- (SEMethod*)dequeueMethod;
- (void)enqueueMethod:(SEMethod*)method;

@end
