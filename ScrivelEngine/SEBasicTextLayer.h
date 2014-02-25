
//
//  _SEConcretTextFrame.h
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrivelEngine.h"
#import "SEBasicLayer.h"
#import "SETextLayer.h"

@interface SEBasicTextLayerClass : SEBasicLayerClass <SETextLayerClass>

@end

@interface SEBasicTextLayer : SEBasicLayer <SETextLayerInstance>

@property (nonatomic, readonly) CATextLayer *textLayer;
@property (nonatomic, readonly) NSTimeInterval animationInterval;
@property (nonatomic, readonly) SEFont *font;
@property (nonatomic, readonly) NSAttributedString *attributedText;
@property (nonatomic, readonly) NSTextAlignment *horizontalAlignment;

@end

