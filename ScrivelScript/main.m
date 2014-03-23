//
//  main.m
//  ScrivelScript
//
//  Created by keroxp on 2014/03/23.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSComandLineTool.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
    // insert code here...
        return [[SSComandLineTool sharedInstance] evaluateWithArgc:argc argv:argv];
    }
    return 0;
}

