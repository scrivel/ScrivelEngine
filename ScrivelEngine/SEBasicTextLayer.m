
//
//  _SEConcretTextFrame.m
//  ScrivelEngine
//
//  Created by 桜井雄介 on 2014/02/18.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicTextLayer.h"

@implementation SEBasicTextLayerClass


@end

@implementation SEBasicTextLayer

/*
 NSString *const NSFontAttributeName;
 NSString *const NSParagraphStyleAttributeName;
 NSString *const NSForegroundColorAttributeName;
 NSString *const NSBackgroundColorAttributeName;
 NSString *const NSLigatureAttributeName;
 NSString *const NSKernAttributeName;
 NSString *const NSStrikethroughStyleAttributeName;
 NSString *const NSUnderlineStyleAttributeName;
 NSString *const NSStrokeColorAttributeName;
 NSString *const NSStrokeWidthAttributeName;
 NSString *const NSShadowAttributeName;
 NSString *const NSTextEffectAttributeName;
 NSString *const NSAttachmentAttributeName;
 NSString *const NSLinkAttributeName;
 NSString *const NSBaselineOffsetAttributeName;
 NSString *const NSUnderlineColorAttributeName;
 NSString *const NSStrikethroughColorAttributeName;
 NSString *const NSObliquenessAttributeName;
 NSString *const NSExpansionAttributeName;
 NSString *const NSWritingDirectionAttributeName;
 NSString *const NSVerticalGlyphFormAttributeName;
 */

+ (instancetype)new_args:(id)args
{
    return [[self alloc] initWithOpts:args];
}

- (instancetype)initWithOpts:(NSDictionary *)options
{
    self = [super initWithOpts:options];
    _textLayer = [CATextLayer layer];
    return self ?: nil;
}

- (void)setInterval_interval:(NSTimeInterval)interval
{
    
}

- (void)setText_text:(NSString *)text noanimate:(BOOL)noanimate
{
	
}

- (void)setPadding_top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    
}

- (void)setFont_name:(NSString *)name size:(CGFloat)size
{
    
}

- (void)setLineSpacing_spacing:(CGFloat)spacing
{
    
}

- (void)clear
{
	
}

- (void)skip
{
	
}


- (void)setVerticalAlign_direction:(NSString *)direction
{
	
}

- (void)setHorizontalAlign_direction:(NSTextAlignment)direction
{
	
}



@end

