//
//  SEElement.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEElement : NSObject

@property (nonatomic, readonly) NSUInteger lineNumber;

- (instancetype)initWithLineNumber:(NSUInteger)lineNumber;

@end
