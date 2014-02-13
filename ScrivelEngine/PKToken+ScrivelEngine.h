//
//  PKToken+ScrivelEngine.h
//  PetiteCouturiere
//
//  Created by 桜井雄介 on 2014/02/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <ParseKit/PKToken.h>

@interface PKToken (ScrivelEngine)

- (BOOL)isStartOfMethod;
- (BOOL)isEndOfMethod;
- (BOOL)isDotChain;
- (BOOL)isCommna;
- (BOOL)isHyphen;

@end
