//
//  SEDScriptsTableViewController.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/22.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SEDScriptsTableViewControllerDelegate;
@interface SEDScriptsTableViewController : UITableViewController

@property (weak) id<SEDScriptsTableViewControllerDelegate> delegate;

@end

@protocol SEDScriptsTableViewControllerDelegate <NSObject>

- (void)scriptsController:(SEDScriptsTableViewController*)controller didSelectScriptPath:(NSString*)scriptPath;

@end
