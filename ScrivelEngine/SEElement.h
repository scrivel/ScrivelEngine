//
//  SEElement.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface SEElement : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSRange rangeOfLines;

- (NSString*)elementName;

@end
