//
//  NSBundle+ScrivelEngine.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/22.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "NSBundle+ScrivelEngine.h"

@implementation NSBundle (ScrivelEngine)


- (NSString *)se_pathForResource:(NSString *)path
{
    NSString *ext = [path pathExtension];
    if ([path rangeOfString:@"/"].location != NSNotFound) {
        // サブディレクトリがある場合
        // sub/dir/hoge.png
        NSMutableArray *dirs = [[path pathComponents] mutableCopy];
        NSMutableArray *_a = [[[dirs lastObject] componentsSeparatedByString:@"."] mutableCopy];
        [_a removeLastObject];
        [dirs removeLastObject];
        NSString *dir = [dirs componentsJoinedByString:@"/"];
        NSString *fn = [_a componentsJoinedByString:@"."];
        return  [[NSBundle mainBundle] pathForResource:fn ofType:ext inDirectory:dir];
    }else{
        // hoge.hoge.png => hoge, hoge, png
        NSArray *comps = [path componentsSeparatedByString:@"."];
        NSString *fn = [[comps subarrayWithRange:NSMakeRange(0, comps.count-1)] componentsJoinedByString:@"."];
        return [[NSBundle mainBundle] pathForResource:fn ofType:ext];
    }
}

@end
