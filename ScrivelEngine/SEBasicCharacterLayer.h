//
//  SEBasicCharacterLayer.h
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicLayer.h"
#import "SECharacterLayer.h"

@interface SEBasicCharacterLayerClass : SEBasicLayerClass <SECharacterLayerClass>

@property (nonatomic, readonly) NSDictionary *definedMotions;
@property (nonatomic, readonly) NSDictionary *markedPoints;

@end

@interface SEBasicCharacterLayer : SEBasicLayer <SECharacterLayerInstance>

@end
