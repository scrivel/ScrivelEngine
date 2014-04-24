//
//  SEStep.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement2.h"

typedef NS_ENUM(NSUInteger, SEStepType){
    SEStepTypeSet,
    SEStepTypeAnimate,
    SEStepTypeWait,
    SEStepTypeDo,
    SEStepTypeCreate,
    SEStepTypeDelete
};

@interface SEStep : SEElement2

@property (nonatomic, weak) id target;

- (SEStep*)reverseStep;

@end
