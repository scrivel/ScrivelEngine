//
//  SEDAppDelegate.h
//  ScrivelEngineMacDemo
//
//  Created by 桜井雄介 on 2014/02/13.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MGSFragaria.h>
#import "ScrivelEngine.h"
#import "SETextLayerDelegate.h"

@interface SEDAppDelegate : NSObject <NSApplicationDelegate,NSToolbarDelegate, SETextLayerDelegate>

@property IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSFontManager *fontManager;
@property (unsafe_unretained) IBOutlet NSPanel *panel;
@property (weak) IBOutlet NSView *panelView;

@end
