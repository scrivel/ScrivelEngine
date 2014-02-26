//
//  MethodSwizzling.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/26.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "MethodSwizzling.h"

static void _se_SwizzleMethod(Class target, SEL from, SEL to, BOOL class)
{
    Method from_m = class ? class_getClassMethod(target, from) : class_getInstanceMethod(target, from);
    Method to_m = class ? class_getClassMethod(target, to) : class_getInstanceMethod(target, to);
    if (from_m) {
        // exchange two methods if the reciever has an impl of method1
        method_exchangeImplementations(from_m, to_m);
    }else{
        // unless no impl of method1, adding it and swizzling again
        IMP imp = method_getImplementation(to_m);
        void (^block)() = ^{};
        imp = imp_implementationWithBlock(block);
        const char *type = method_getTypeEncoding(to_m);
        class_addMethod(target, from, imp, type);
        _se_SwizzleMethod(target,from,to,class);
    }
}

static void se_SwizzleClassMethod(Class cls, SEL from, SEL to){
    _se_SwizzleMethod(cls, from, to, YES);
}
static void se_SwizzleInstanceMethod(Class cls, SEL from, SEL to){
    _se_SwizzleMethod(cls, from, to, NO);
}
