//
//  SSComandLineTool.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/23.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSComandLineTool : NSObject

+ (instancetype)sharedInstance;

- (int)evaluateWithArgc:(int)argc argv:(const char *[])argv;

@end
