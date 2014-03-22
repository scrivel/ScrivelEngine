//
//  SEDViewController.m
//  ScrivelEngineDemo
//
//  Created by keroxp on 2014/02/13.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEDViewController.h"
#import <ScrivelEngine.h>
#import "SEDScriptsTableViewController.h"
#import <SEBasicLayer.h>
#import <SEBasicTextLayer.h>
#import <SEBasicCharacterLayer.h>

@interface SEDViewController ()
{
    ScrivelEngine *_engine;
    NSString *_str;
    NSArray *_files;
}

@property (weak, nonatomic) IBOutlet UIButton *scriptsButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *engineView;

@end

@implementation SEDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _engine = [ScrivelEngine new];
    _engine.rootView = self.engineView;
    _files = [[NSBundle mainBundle] pathsForResourcesOfType:@"sescript" inDirectory:@"Scripts.bundle"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SEDScriptsTableViewController *sv = (SEDScriptsTableViewController*)[(UINavigationController*)segue.destinationViewController topViewController];
    sv.delegate = self;
}

- (void)scriptsController:(SEDScriptsTableViewController *)controller didSelectScriptPath:(NSString *)scriptPath
{
    NSError *e = nil;
    NSString *script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&e];
    self.textView.text = script;
    [self.scriptsButton setTitle:[[scriptPath pathComponents] lastObject] forState:UIControlStateNormal];
}

- (IBAction)action:(id)sender {
    NSError *e = nil;
    if ([_engine validateScript:self.textView.text error:&e]) {
        id ret = [_engine evaluateScript:self.textView.text error:&e];
        NSLog(@"%@",ret);
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:e.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
    }
}

- (IBAction)handleClear:(id)sender {
    [(SEBasicLayerClass*)_engine.layer clearAll];
    [(SEBasicLayerClass*)_engine.text clearAll];
    [(SEBasicLayerClass*)_engine.chara clearAll];
    [_engine.elementQueue clear];
    [_engine.methodQueue clear];
}

@end
