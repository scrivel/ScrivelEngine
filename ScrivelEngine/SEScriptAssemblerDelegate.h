
//
//  SEScriptAssemblerDelegate.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/15.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>

@protocol SEScriptAssemblerDelegate <NSObject>

- (void)parser:(PKParser*)parser didMatchScript:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchElement:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchWords:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchName:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchText:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchMethodChain:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchMethod:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArguments:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchArray:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchObject:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchKeyValue:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchKey:(PKAssembly*)assembly;
- (void)parser:(PKParser*)parser didMatchIdentifier:(PKAssembly*)assembly;

@end

