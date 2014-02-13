//
//  SEScript.h
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/ParseKit.h>
#import "PKToken+ScrivelEngine.h"
#import "SEMethod.h"
#import "SEObject.h"

enum{
    SEScriptParseErrorUnknown = 0,
    SEScriptParseErrorNilStringGiven,
    SEScriptParseErrorObjectNotSpecified,
    SEScriptParseErrorObjectNotFound,
    SEScriptParseErrorMethodNotCalled,
    SEScriptParseErrorUnexpectedToken
};
typedef NSInteger SEScriptParseError;


@class SEObject, SEMethod;
@interface SEScript : NSObject

+ (instancetype)scriptWithString:(NSString*)string error:(NSError**)error;

- (instancetype)initWithTarget:(SEObject*)target;

@property (nonatomic) SEObject *target;
@property (nonatomic) NSArray *methods;

- (void)addMethod:(SEMethod*)method;
- (void)removeMethod:(SEMethod*)method;

- (id)run;

@end
