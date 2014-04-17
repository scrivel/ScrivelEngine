//
//  SEDAppDelegate.m
//  ScrivelEngineMacDemo
//
//  Created by keroxp on 2014/02/13.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEDAppDelegate.h"
#import "ScrivelEngine.h"
#import "SEBasicLayer.h"
#import "Queue.h"

@interface SEDAppDelegate ()
{
    MGSFragaria *fragaria;
    ScrivelEngine *_engine;
}
@property (weak) IBOutlet NSView *editorView;
@property (weak) IBOutlet NSView *panelView;
@property (weak) IBOutlet NSPopUpButton *popupButton;
@property (weak) IBOutlet NSTextField *textField;

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
    [[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:[NSFont fontWithName:@"Menlo Bold" size:16.0f]] forKey:MGSFragariaPrefsTextFont];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutocompleteSuggestAutomatically];
    [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:MGSFragariaPrefsAutomaticLinkDetection];
    [[NSUserDefaults standardUserDefaults] setObject:@(0.5) forKey:MGSFragariaPrefsAutocompleteAfterDelay];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutoInsertAClosingBrace];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutoInsertAClosingParenthesis];
    [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:MGSFragariaPrefsAutomaticallyIndentBraces];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MGSFragariaPrefsAutomaticQuoteSubstitution];
    
    fragaria = f;

    // engine
    _engine = [ScrivelEngine new];
    self.panelView.wantsLayer = YES;
    _engine.rootView = self.panelView;

    NSArray *scripts = [[NSBundle mainBundle] pathsForResourcesOfType:@"sescript" inDirectory:@"Scripts.bundle"];
    for (NSString *path in scripts) {
        NSURL *url = [NSURL URLWithString:path];
        [self.popupButton addItemWithTitle:[[url pathComponents] lastObject]];
    }
    [self.popupButton selectItemAtIndex:0];
    [self popup:self.popupButton];
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

- (IBAction)clear:(id)sender {
    [_engine clear];
}
- (IBAction)input:(id)sender {
    [_engine setSpeed:self.textField.floatValue];
    NSLog(@"%@",self.textField.stringValue);
}

- (IBAction)popup:(NSPopUpButton*)sender {
    NSString *title = sender.selectedItem.title;
    NSString *p = [[NSBundle mainBundle] pathForResource:title ofType:nil inDirectory:@"Scripts.bundle"];
    NSString *s = [NSString stringWithContentsOfFile:p encoding:NSUTF8StringEncoding error:nil];
    [fragaria setString:s];
    [fragaria reloadString];
}


@end
