//
//  SEObjectStep.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/04/24.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEStep.h"

typedef NS_ENUM(NSUInteger, SEObjectStepTarget){
    SEObjectStepTargetLayer,
    SEObjectStepTargetTextLayer,
    SEObjectStepTargetCharacterLayer
};
@interface SEObjectStep : SEStep

@property (nonatomic) SEObjectStepTarget objectStepTarget;

@end
