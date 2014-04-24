//
//  SEGeometory.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEUnitValue.h"
#import "SEUnitPoint.h"
#import "SEUnitSize.h"
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
extern CGFloat SEMakeX(SEUnitValue *f, CGFloat constraint, CGFloat virtualConstraint);
extern CGFloat SEMakeY(SEUnitValue *f, CGFloat constraint, CGFloat virtualConstraint);
extern CGPoint CGPointFromObject(id obj);
extern SESize SESizeMake(id w , id h, SESize constraintSize, SESize virtualConstraintSize);
extern SEPoint SEPointMake(id x, id y, SESize constraintSize, SESize virtualConstraintSize);
extern SERect SERectMake(id x, id y, id w, id h, SESize constraintSize, SESize virtualConstraintSize);
extern SEVector SEVectorMake(id dx, id dy, SESize constraintSize, SESize virtualConstraintSize);
extern SESize SESizeFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize);
extern SESize SESizeFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize);
extern SESize SESizeFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize);
extern SEPoint SEPointFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize);
extern SEPoint SEPointFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize);
extern SEPoint SEPointFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize);
extern SEVector SEVectorFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize);
extern SEVector SEVectorFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize);
extern SEVector SEVectorFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize);
extern SERect SERectFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize);
extern SERect SERectFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize);
extern SERect SERectFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize);
extern SEEdgeInsets SEEdgeInsetsFromArray(NSArray *array, SESize constraintSize, SESize virtualConstraintSize);
extern SEEdgeInsets SEEdgeInsetsFromDictionary(NSDictionary *dictionary, SESize constraintSize, SESize virtualConstraintSize);
extern SEEdgeInsets SEEdgeInsetsFromObject(id obj, SESize constraintSize, SESize virtualConstraintSize);
extern CGFloat SEMakeRadian (CGFloat degree);
extern CGFloat SENormalize(CGFloat f);

#endif