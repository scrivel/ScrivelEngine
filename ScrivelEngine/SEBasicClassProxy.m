
#import "SEBasicClassProxy.h"
#import "SEBasicObject.h"
#import "SEBasicLayer.h"
#import "SEBasicTextLayer.h"

@implementation SEBasicClassProxy

#define SEL_FOR_METHOD(_m,_s) if([methodIdentifier isEqualToString:_m]) return @selector(_s)

+ (Class)classForClassIdentifier:(NSString *)classIdentifier
{
    if ([classIdentifier isEqualToString:@"layer"]) {
        // レイヤー
        return [SEBasicLayer class];
    }else if ([classIdentifier isEqualToString:@"chara"]){
        // キャラ
    }else if ([classIdentifier isEqualToString:@"bg"]){
        // 背景
    }else if ([classIdentifier isEqualToString:@"text"]){
        // テクストフレーム
        return [SEBasicTextLayer class];
    }else if ([classIdentifier isEqualToString:@"ui"]){
        // UI
    }else if ([classIdentifier isEqualToString:@"bgm"]){
        // BGM
    }else if ([classIdentifier isEqualToString:@"se"]){
        // SE
    }
    return nil;
}

+ (SEL)selectorForMethodIdentifier:(NSString *)methodIdentifier
{

	// layer

	SEL_FOR_METHOD(@"new",new_options:);
	SEL_FOR_METHOD(@"at",at_index:);
	SEL_FOR_METHOD(@"setAnchorPoint",set_anchorPoint_x:y:);
	SEL_FOR_METHOD(@"setPositionType",set_positionType_type:);
	SEL_FOR_METHOD(@"setImage",loadImage_path:options:);
	SEL_FOR_METHOD(@"clearImage",clearImage);
	SEL_FOR_METHOD(@"clear",clear);
	SEL_FOR_METHOD(@"bg",bg_color:);
	SEL_FOR_METHOD(@"border",border_width:color:);
	SEL_FOR_METHOD(@"shadow",shadow_options:);
	SEL_FOR_METHOD(@"beginAnimation",beginAnimation_duration:);
	SEL_FOR_METHOD(@"commitAnimation",commitAnimation);
	SEL_FOR_METHOD(@"position",position_x:y:duration:);
	SEL_FOR_METHOD(@"zPosition",zPosition_z:duration:);
	SEL_FOR_METHOD(@"size",size_width:duration:);
	SEL_FOR_METHOD(@"show",show_duration:);
	SEL_FOR_METHOD(@"hide",hide_duration:);
	SEL_FOR_METHOD(@"toggle",toggle_duration:);
	SEL_FOR_METHOD(@"translate",translate_x:y:z:duration:);
	SEL_FOR_METHOD(@"scale",scale_ratio:duration:);
	SEL_FOR_METHOD(@"rotate",rotate_degree:duration:);
	SEL_FOR_METHOD(@"opacity",opacity_ratio:duration:);

	// abstract

	SEL_FOR_METHOD(@"new",new_options:);
	SEL_FOR_METHOD(@"callStatic",callStatic_method:engine:);
	SEL_FOR_METHOD(@"callInstance",callInstance_method:engine:);
	SEL_FOR_METHOD(@"wait",wait_duration:);

	// text

	SEL_FOR_METHOD(@"interval",set_interval:);
	SEL_FOR_METHOD(@"font",set_font:);
	SEL_FOR_METHOD(@"text",set_text:noanimate:);
	SEL_FOR_METHOD(@"name",set_name:);
	SEL_FOR_METHOD(@"clear",clear);
	SEL_FOR_METHOD(@"skip",skip);
	SEL_FOR_METHOD(@"padding",set_padding:);
	SEL_FOR_METHOD(@"verticalAlign",set_verticalAlign:);
	SEL_FOR_METHOD(@"horizontalAlign",set_horizontalAlign:);


    return nil;
}

@end

