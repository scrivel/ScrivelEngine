//
//  SEDAppDelegate.m
//  ScrivelEngineMacDemo
//
//  Created by 桜井雄介 on 2014/02/13.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEDAppDelegate.h"

@interface SEDAppDelegate ()
{
    MGSFragaria *fragaria;
}
@property (weak) IBOutlet NSView *editorView;

@end
@implementation SEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    MGSFragaria *f = [[MGSFragaria alloc] init];
    [f setObject:self forKey:MGSFODelegate];
    [f setObject:@"Objective-C" forKey:MGSFOSyntaxDefinitionName];
    [f embedInView:self.editorView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"sescript"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [f setString:str];
    fragaria = f;
}

@end
