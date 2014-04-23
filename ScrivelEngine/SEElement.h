//
//  SEElement.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEElement : NSObject

@property (nonatomic) NSRange rangeOfLines;
@property (nonatomic, readonly) NSString *elementName;

@end
