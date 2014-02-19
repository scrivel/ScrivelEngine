//
//  ScrivelEngine.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrivelEngine : NSObject

@property (nonatomic, weak) SEView *rootView;

- (Class)classForClassIdentifier:(NSString*)classIdentifier;

// SEScriptを実行
- (BOOL)evaluateScript:(NSString*)script error:(NSError**)error;

@end

