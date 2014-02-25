//
//  SEDViewController.m
//  ScrivelEngineDemo
//
//  Created by 桜井雄介 on 2014/02/13.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEDViewController.h"
#import <ScrivelEngine.h>

@interface SEDViewController ()
{
    ScrivelEngine *_engine;
    NSString *_str;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SEDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _engine = [ScrivelEngine new];
    _engine.rootView = self.view;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"animate" ofType:@"sescript"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    _str = str;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _textView.text = _str;
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
- (IBAction)action:(id)sender {
    NSError *e = nil;
    id ret = [_engine evaluateScript:self.textView.text error:&e];
    NSLog(@"%@",ret);
}
- (IBAction)cloase:(id)sender {
    [self.textView resignFirstResponder];
}

@end
