//
//  MethodSwizzling.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/26.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static void se_SwizzleClassMethod(Class cls, SEL from, SEL to);
static void se_SwizzleInstanceMethod(Class cls, SEL from, SEL to);
static void se_SwizzleClassMethod_(Method from, Method to);
static void se_SwizzleInstanceMethod_(Method from, Method to);