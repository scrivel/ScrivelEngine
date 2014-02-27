//
//  SETextLayerDelegate.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SETextLayer.h"

@protocol SETextLayerDelegate <NSObject>

@required
- (void)textLayer:(id<SETextLayerInstance>)textLayer didFinishDisplayText:(id)text;
- (void)textLayerDidRecognizeTapTwice:(id<SETextLayerInstance>)textLayer;

@end
