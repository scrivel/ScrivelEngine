//
//  SSComandLineTool.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/23.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SSComandLineTool.h"
#import "Queue.h"
#import "SEScript.h"

static id shared;
@implementation SSComandLineTool

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (int)evaluateWithArgc:(int)argc argv:(const char * [])argv
{
    //        NSLog(@"Hello, World!");
    Queue *arguments = [Queue new];
    for (NSUInteger i = 1; i < argc; i++) {
        [arguments enqueue:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
    }
    // -json [path] json
    // -o [path] output
    // -c [path] check
    NSString *arg;
    NSError *e = nil;
    SEScript *script = nil;
    while ((arg = [arguments dequeue]) != nil) {
        if ([arg isEqualToString:@"-c"]) {
            if ((script = [self readScriptAtPath:[arguments dequeue] error:&e])) {
                NSLog(@"CHECK SUCCESSED");
                return 0;
            }else{
                return 2;
            }
        }else if ([arg isEqualToString:@"-json"]){
            arg = [arguments dequeue];
            NSString *filename = [arg lastPathComponent];
            NSString *dir = [[NSFileManager defaultManager] currentDirectoryPath];
            NSString *output = [NSString stringWithFormat:@"%@/%@.json",dir,filename];
            if ((script = [self readScriptAtPath:arg error:&e])) {
                if ([[arguments dequeue] isEqualToString:@"-o"]) {
                    arg = [arguments dequeue];
                    if ([arg characterAtIndex:arg.length-1] == '/') {
                        output = [arg stringByAppendingString:filename];
                    }else{
                        output = arg;
                    }
                }
                if ([[script JSONString] writeToFile:output atomically:YES encoding:NSUTF8StringEncoding error:&e]) {
                    NSLog(@"%@ has been created.",output);
                    return 0;
                }else{
                    NSLog(@"out failed : %@ : %@",filename,e);
                    return 2;
                }
            }else{
                return 2;
            }
        }
    }
    return 0;
}

- (SEScript*)readScriptAtPath:(NSString*)path error:(NSError**)error
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:error];
        if (*error) {
            NSLog(@"cannot read file : %@",path);
            NSLog(@"%@",*error);
            return nil;
        }
        SEScript *s = [SEScript scriptWithString:script error:error];
        if (*error) {
            NSLog(@"syntax error : ");
            NSLog(@"%@",*error);
            return nil;
        }
        return s;
    }else{
        NSLog(@"file not exitsts : %@",path);
    }
    return nil;
}

@end
