//
//  SEMethodChain.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEMethodChain.h"
#import "SEObject.h"
#import "SEGlobalObject.h"
#import "SEMethod.h"
#import "ScrivelEngine.h"

@implementation SEMethodChain

- (instancetype)initWithLineNumber:(NSUInteger)lineNumber
{
    self = [super initWithLineNumber:lineNumber];
    _methods = [NSMutableArray new];
    return self ?: nil;
}

@end
