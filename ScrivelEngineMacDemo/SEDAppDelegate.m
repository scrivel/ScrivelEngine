//
//  SEDAppDelegate.m
//  ScrivelEngineMacDemo
//
//  Created by keroxp on 2014/02/13.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEDAppDelegate.h"
#import "ScrivelEngine.h"

@interface SEDAppDelegate ()
{
    MGSFragaria *fragaria;
    ScrivelEngine *_engine;
}
@property (weak) IBOutlet NSView *editorView;
@property (weak) IBOutlet NSView *panelView;

@end
@implementation SEDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Fragaria
    MGSFragaria *f = [[MGSFragaria alloc] init];
    [f setObject:self forKey:MGSFODelegate];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:[NSFont fontWithName:@"Menlo Bold" size:16.0f]] forKey:MGSFragariaPrefsTextFont];    
    [f setObject:@"SEScript" forKey:MGSFOSyntaxDefinitionName];
    [f embedInView:self.editorView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"animate" ofType:@"sescript"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:[NSFont fontWithName:@"Menlo Bold" size:16.0f]] forKey:MGSFragariaPrefsTextFont];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutocompleteSuggestAutomatically];
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:MGSFragariaPrefsAutomaticLinkDetection];
    [[NSUserDefaults standardUserDefaults] setObject:@(0.5) forKey:MGSFragariaPrefsAutocompleteAfterDelay];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutoInsertAClosingBrace];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutoInsertAClosingParenthesis];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutomaticallyIndentBraces];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MGSFragariaPrefsAutomaticQuoteSubstitution];
    
    [f setString:str];
    fragaria = f;

    // engine
    _engine = [ScrivelEngine new];
    self.panelView.wantsLayer = YES;
    _engine.rootView = self.panelView;
    
}
- (IBAction)run:(id)sender {
    NSLog(@"%@",sender);
    id ret;
    NSTextView *v = [fragaria objectForKey:ro_MGSFOTextView];
    NSError *e = nil;
//    // validate
    if (![_engine validateScript:v.string error:&e]) {
        NSAlert *av = [NSAlert alertWithError:e];
        [av runModal];
    }else{
        ret = [_engine evaluateScript:v.string error:&e];
        NSLog(@"%@",ret);
    }
}

@end
