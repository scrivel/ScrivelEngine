//
//  MethodSwizzling.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/26.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern void se_SwizzleClassMethod(Class cls, SEL from, SEL to);
extern void se_SwizzleInstanceMethod(Class cls, SEL from, SEL to);
