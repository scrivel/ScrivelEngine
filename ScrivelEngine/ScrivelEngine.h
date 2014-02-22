//
//  ScrivelEngine.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/16.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#define SEView UIView
typedef CGPoint SEPoint;
typedef CGRect SERect;
typedef CGSize SESize;
#elif TARGET_OS_MAC
#define SEView NSView
typedef NSPoint SEPoint;
typedef NSRect SERect;
typedef NSSize SESize;
#endif

@interface ScrivelEngine : NSObject

@property (nonatomic, weak) SEView *rootView;

- (Class)classForClassIdentifier:(NSString*)classIdentifier;

// SEScriptを実行
- (id)evaluateScript:(NSString*)script error:(NSError**)error;

@end

