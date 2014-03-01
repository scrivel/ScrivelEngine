//
//  SEDAppDelegate.h
//  ScrivelEngineMacDemo
//
//  Created by keroxp on 2014/02/13.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MGSFragaria.h>
#import "ScrivelEngine.h"

@interface SEDAppDelegate : NSObject <NSApplicationDelegate,NSToolbarDelegate>

@property IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSFontManager *fontManager;

@end
