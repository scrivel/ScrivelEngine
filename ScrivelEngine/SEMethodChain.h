//
//  SEMethodChain.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "Queue.h"
#import "SEObject.h"

@class SEMethod;

@interface SEMethodChain : NSObject <NSFastEnumeration>

@property (nonatomic, readonly) NSUInteger lineNumber;

- (instancetype)initWithLineNumber:(NSUInteger)lineNumber targetClass:(NSString*)targetClass;

@property (nonatomic, readonly) NSString *targetClass;
// メソッドチェーンを構成するメソッドら
@property (nonatomic, readonly) NSMutableArray *methods;

- (SEMethod*)dequeueMethod;
- (void)enqueueMethod:(SEMethod*)method;

@end
