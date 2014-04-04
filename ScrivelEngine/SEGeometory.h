//
//  SEGeometory.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEUnitValue.h"
#import "NSNumber+CGFloat.h"
#import "NSValue+ScrivelEngine.h"

@class SEUnitValue;

#ifndef ScrivelEngine_SEGeometory_h
#define ScrivelEngine_SEGeometory_h

#define VALID_CGFLOAT(d) ((CGFloat)d != SENilCGFloat)
#define ROUND_CGFLOAT(d) (VALID_CGFLOAT(d) ? d : (CGFloat)0.0)
#define VALID_DOUBLE(d) ((double)d != SENilDouble)
#define ROUND_DOUBLE(d) (VALID_DOUBLE(d) ? d : (double)0.0)
#define VALID_INT(i) (i != SENilInteger)
#define VALID_UINT(i) (I != SENilUInteger)

extern SEUnitValue * SEUnitValueMake(id obj);
extern CGFloat SEMakeX(CGFloat constraint, SEUnitValue *f);
extern CGFloat SEMakeY(CGFloat constraint, SEUnitValue *f);
extern CGPoint CGPointFromObject(id obj);
extern SESize SESizeMake(SESize constraintSize, id w , id h);
extern SEPoint SEPointMake(SESize constraintSize, id x, id y);
extern SERect SERectMake(SESize constraintSize, id x, id y, id w, id h);
extern SEVector SEVectorMake(SESize constraintSize, id dx, id dy);
extern SESize SESizeFromArray(SESize constraintSize, NSArray *array);
extern SESize SESizeFromDictionary(SESize constraintSize, NSDictionary *dictionary);
extern SESize SESizeFromObject(SESize constraintSize, id obj);
extern SEPoint SEPointFromArray(SESize constraintSize, NSArray *array);
extern SEPoint SEPointFromDictionary(SESize constraintSize, NSDictionary *dictionary);
extern SEPoint SEPointFromObject(SESize constraintSize, id obj);
extern SEVector SEVectorFromArray(SESize constraintSize, NSArray *array);
extern SEVector SEVectorFromDictionary(SESize constraintSize, NSDictionary *dictionary);
extern SEVector SEVectorFromObject(SESize constraintSize, id obj);
extern SERect SERectFromArray(SESize constraintSize, NSArray *array);
extern SERect SERectFromDictionary(SESize constraintSize, NSDictionary *dictionary);
extern SERect SERectFromObject(SESize constraintSize, id obj);
extern SEEdgeInsets SEEdgeInsetsFromArray(SESize constraintSize, NSArray *array);
extern SEEdgeInsets SEEdgeInsetsFromDictionary(SESize constraintSize, NSDictionary *dictionary);
extern SEEdgeInsets SEEdgeInsetsFromObject(SESize constraintSize, id obj);
extern CGFloat SEMakeRadian (CGFloat degree);
extern CGFloat SENormalize(CGFloat f);

#endif