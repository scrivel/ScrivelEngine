
#import "SEBasicClassProxy.h"
#import "SEBasicApp.h"
#import "SEBasicObject.h"
#import "SEBasicLayer.h"
#import "SEBasicTextLayer.h"

@implementation SEBasicClassProxy

#define SEL_FOR_METHOD(_m,_s) if([methodIdentifier isEqualToString:_m]) return @selector(_s)

- (Class)classForClassIdentifier:(NSString *)classIdentifier
{
    if ([classIdentifier isEqualToString:@"app"]) {
        return [SEBasicApp class];
    }else if ([classIdentifier isEqualToString:@"layer"]) {
        // レイヤー
        return [SEBasicLayerClass class];
    }else if ([classIdentifier isEqualToString:@"chara"]){
        // キャラ
    }else if ([classIdentifier isEqualToString:@"bg"]){
        // 背景
    }else if ([classIdentifier isEqualToString:@"text"]){
        // テクストフレーム
        return [SEBasicTextLayerClass class];
    }else if ([classIdentifier isEqualToString:@"ui"]){
        // UI
    }else if ([classIdentifier isEqualToString:@"bgm"]){
        // BGM
    }else if ([classIdentifier isEqualToString:@"se"]){
        // SE
    }
    return nil;
}

- (SEL)selectorForMethodIdentifier:(NSString *)methodIdentifier
{

	// App

	SEL_FOR_METHOD(@"setPositionType",setPositionType_type:);
	SEL_FOR_METHOD(@"positioinType",positionType);
	SEL_FOR_METHOD(@"setSizeType",setSizeType_type:);
	SEL_FOR_METHOD(@"sizeType",sizeType);

	// Layer

	SEL_FOR_METHOD(@"new",new_args:);
	SEL_FOR_METHOD(@"at",at_index:);
	SEL_FOR_METHOD(@"clear",clear_index:);
	SEL_FOR_METHOD(@"setAnchorPoint",setAnchorPoint_x:y:);
	SEL_FOR_METHOD(@"gravity",setGravity_gravity:);
	SEL_FOR_METHOD(@"loadImage",loadImage_path:duration:);
	SEL_FOR_METHOD(@"clearImage",clearImage_duration:);
	SEL_FOR_METHOD(@"bg",bg_color:);
	SEL_FOR_METHOD(@"border",border_width:color:);
	SEL_FOR_METHOD(@"shadowOffset",shadowOffset_x:y:);
	SEL_FOR_METHOD(@"shadowColor",shadowColor_color:);
	SEL_FOR_METHOD(@"shadowOpacity",shadowOpcity_opacity:);
	SEL_FOR_METHOD(@"shadowRadius",shadowRadius_radius:);
	SEL_FOR_METHOD(@"beginAnimation",beginAnimation_duration:);
	SEL_FOR_METHOD(@"commitAnimation",commitAnimation);
	SEL_FOR_METHOD(@"position",position_x:y:duration:);
	SEL_FOR_METHOD(@"zPosition",zPosition_z:duration:);
	SEL_FOR_METHOD(@"size",size_width:height:duration:);
	SEL_FOR_METHOD(@"show",show);
	SEL_FOR_METHOD(@"hide",hide);
	SEL_FOR_METHOD(@"toggle",toggle);
	SEL_FOR_METHOD(@"fadeIn",fadeIn_duration:);
	SEL_FOR_METHOD(@"fadeOut",fadeOut_duration:);
	SEL_FOR_METHOD(@"translate",translate_x:y:duration:);
	SEL_FOR_METHOD(@"translateZ",translateZ_z:duration:);
	SEL_FOR_METHOD(@"scale",scale_ratio:duration:);
	SEL_FOR_METHOD(@"rotate",rotate_degree:duration:);
	SEL_FOR_METHOD(@"opacity",opacity_ratio:duration:);

	// Abstract

	SEL_FOR_METHOD(@"new",new_args:);
	SEL_FOR_METHOD(@"callStatic",callStatic_method:);
	SEL_FOR_METHOD(@"callInstance",callInstance_method:);

	// Text

	SEL_FOR_METHOD(@"interval",setInterval_interval:);
	SEL_FOR_METHOD(@"font",setFont_name:size:);
	SEL_FOR_METHOD(@"lineSpacing",setLineSpacing_spacing:);
	SEL_FOR_METHOD(@"text",text_text:noanimate:);
	SEL_FOR_METHOD(@"start",start);
	SEL_FOR_METHOD(@"pause",pause);
	SEL_FOR_METHOD(@"resume",resume);
	SEL_FOR_METHOD(@"clear",clear);
	SEL_FOR_METHOD(@"skip",skip);
	SEL_FOR_METHOD(@"padding",setPadding_top:left:bottom:right:);
	SEL_FOR_METHOD(@"horizontalAlign",setHorizontalAlign_direction:);


    return nil;
}

@end

