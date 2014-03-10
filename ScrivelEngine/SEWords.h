//
//  SEWords.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEElement.h"

@interface SEWords : SEElement

- (instancetype)initWithCharacter:(NSString*)character arguments:(NSArray*)arguments;

@property (nonatomic, readonly) NSString *character;
@property (nonatomic, readonly) NSArray *arguments;

- (NSString*)text;
- (NSDictionary*)options;

@end
