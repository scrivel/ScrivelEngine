
#import "SEBasicClassProxy.h"
#import "SEBasicApp.h"
#import "SEBasicObject.h"
#import "SEBasicLayer.h"
#import "SEBasicTextLayer.h"
#import "SEBasicCharacterLayer.h"

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
        return [SEBasicCharacterLayerClass class];
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

- (SEL)selectorForMethodIdentifier:(NSString *)methodIdentifier classIdentifier:(NSString *)classIdentifier
{
	if ([classIdentifier isEqualToString:@"abstract"]) {
		// abstract

		// inherited from abstract
		SEL_FOR_METHOD(@"callMethod",callMethod_method:);
		SEL_FOR_METHOD(@"wait",wait_duration:);
		SEL_FOR_METHOD(@"waitTap",waitTap);
		SEL_FOR_METHOD(@"waitText",waitText);
		SEL_FOR_METHOD(@"waitAnimation",waitAnimation);
		SEL_FOR_METHOD(@"set",set_key:value:);
		SEL_FOR_METHOD(@"enable",enable_key:enable:);
		SEL_FOR_METHOD(@"alias",alias_alias:method:);
		SEL_FOR_METHOD(@"new",new_args:);

	}
	if ([classIdentifier isEqualToString:@"app"]) {
		// app

		// inherited from app
		SEL_FOR_METHOD(@"load",load_scriptPath:);
		// inherited from abstract
		SEL_FOR_METHOD(@"callMethod",callMethod_method:);
		SEL_FOR_METHOD(@"wait",wait_duration:);
		SEL_FOR_METHOD(@"waitTap",waitTap);
		SEL_FOR_METHOD(@"waitText",waitText);
		SEL_FOR_METHOD(@"waitAnimation",waitAnimation);
		SEL_FOR_METHOD(@"set",set_key:value:);
		SEL_FOR_METHOD(@"enable",enable_key:enable:);
		SEL_FOR_METHOD(@"alias",alias_alias:method:);
		SEL_FOR_METHOD(@"new",new_args:);

	}
	if ([classIdentifier isEqualToString:@"layer"]) {
		// layer

		// inherited from layer
		SEL_FOR_METHOD(@"new",new_args:);
		SEL_FOR_METHOD(@"get",get_key:);
		SEL_FOR_METHOD(@"clear",clear_key:);
		SEL_FOR_METHOD(@"clearAll",clearAll);
		SEL_FOR_METHOD(@"defineAnimation",defineAnimation_name:animations:options:);
		SEL_FOR_METHOD(@"loadImage",loadImage_path:);
		SEL_FOR_METHOD(@"clearImage",clearImage_duration:);
		SEL_FOR_METHOD(@"transact",transact_duration:animations:options:);
		SEL_FOR_METHOD(@"chain",chain);
		SEL_FOR_METHOD(@"commit",commit);
		SEL_FOR_METHOD(@"stop",stop);
		SEL_FOR_METHOD(@"pause",pause);
		SEL_FOR_METHOD(@"resume",resume);
		SEL_FOR_METHOD(@"show",show);
		SEL_FOR_METHOD(@"hide",hide);
		SEL_FOR_METHOD(@"toggle",toggle);
		SEL_FOR_METHOD(@"fadeIn",fadeIn_duration:);
		SEL_FOR_METHOD(@"fadeOut",fadeOut_duration:);
		SEL_FOR_METHOD(@"animate",animate_key:value:duration:options:);
		SEL_FOR_METHOD(@"do",do_animationName:duration:);
		// inherited from abstract
		SEL_FOR_METHOD(@"callMethod",callMethod_method:);
		SEL_FOR_METHOD(@"wait",wait_duration:);
		SEL_FOR_METHOD(@"waitTap",waitTap);
		SEL_FOR_METHOD(@"waitText",waitText);
		SEL_FOR_METHOD(@"waitAnimation",waitAnimation);
		SEL_FOR_METHOD(@"set",set_key:value:);
		SEL_FOR_METHOD(@"enable",enable_key:enable:);
		SEL_FOR_METHOD(@"alias",alias_alias:method:);
		SEL_FOR_METHOD(@"new",new_args:);

	}
	if ([classIdentifier isEqualToString:@"text"]) {
		// text

		// inherited from text
		SEL_FOR_METHOD(@"setText",setText_text:noanimate:);
		SEL_FOR_METHOD(@"start",start);
		SEL_FOR_METHOD(@"clear",clear);
		SEL_FOR_METHOD(@"skip",skip);
		// inherited from layer
		SEL_FOR_METHOD(@"new",new_args:);
		SEL_FOR_METHOD(@"get",get_key:);
		SEL_FOR_METHOD(@"clear",clear_key:);
		SEL_FOR_METHOD(@"clearAll",clearAll);
		SEL_FOR_METHOD(@"defineAnimation",defineAnimation_name:animations:options:);
		SEL_FOR_METHOD(@"loadImage",loadImage_path:);
		SEL_FOR_METHOD(@"clearImage",clearImage_duration:);
		SEL_FOR_METHOD(@"transact",transact_duration:animations:options:);
		SEL_FOR_METHOD(@"chain",chain);
		SEL_FOR_METHOD(@"commit",commit);
		SEL_FOR_METHOD(@"stop",stop);
		SEL_FOR_METHOD(@"pause",pause);
		SEL_FOR_METHOD(@"resume",resume);
		SEL_FOR_METHOD(@"show",show);
		SEL_FOR_METHOD(@"hide",hide);
		SEL_FOR_METHOD(@"toggle",toggle);
		SEL_FOR_METHOD(@"fadeIn",fadeIn_duration:);
		SEL_FOR_METHOD(@"fadeOut",fadeOut_duration:);
		SEL_FOR_METHOD(@"animate",animate_key:value:duration:options:);
		SEL_FOR_METHOD(@"do",do_animationName:duration:);
		// inherited from abstract
		SEL_FOR_METHOD(@"callMethod",callMethod_method:);
		SEL_FOR_METHOD(@"wait",wait_duration:);
		SEL_FOR_METHOD(@"waitTap",waitTap);
		SEL_FOR_METHOD(@"waitText",waitText);
		SEL_FOR_METHOD(@"waitAnimation",waitAnimation);
		SEL_FOR_METHOD(@"set",set_key:value:);
		SEL_FOR_METHOD(@"enable",enable_key:enable:);
		SEL_FOR_METHOD(@"alias",alias_alias:method:);
		SEL_FOR_METHOD(@"new",new_args:);

	}
	if ([classIdentifier isEqualToString:@"chara"]) {
		// chara

		// inherited from chara
		SEL_FOR_METHOD(@"mark",mark_key:x:y:);
		SEL_FOR_METHOD(@"defineMotion",defineMotion_name:);
		SEL_FOR_METHOD(@"defineExpression",defineExpression_name:imagePath:);
		SEL_FOR_METHOD(@"express",express_name:duration:);
		SEL_FOR_METHOD(@"exit",exit_info:);
		SEL_FOR_METHOD(@"appear",appear_info:);
		SEL_FOR_METHOD(@"motion",motion_name:options:);
		// inherited from layer
		SEL_FOR_METHOD(@"new",new_args:);
		SEL_FOR_METHOD(@"get",get_key:);
		SEL_FOR_METHOD(@"clear",clear_key:);
		SEL_FOR_METHOD(@"clearAll",clearAll);
		SEL_FOR_METHOD(@"defineAnimation",defineAnimation_name:animations:options:);
		SEL_FOR_METHOD(@"loadImage",loadImage_path:);
		SEL_FOR_METHOD(@"clearImage",clearImage_duration:);
		SEL_FOR_METHOD(@"transact",transact_duration:animations:options:);
		SEL_FOR_METHOD(@"chain",chain);
		SEL_FOR_METHOD(@"commit",commit);
		SEL_FOR_METHOD(@"stop",stop);
		SEL_FOR_METHOD(@"pause",pause);
		SEL_FOR_METHOD(@"resume",resume);
		SEL_FOR_METHOD(@"show",show);
		SEL_FOR_METHOD(@"hide",hide);
		SEL_FOR_METHOD(@"toggle",toggle);
		SEL_FOR_METHOD(@"fadeIn",fadeIn_duration:);
		SEL_FOR_METHOD(@"fadeOut",fadeOut_duration:);
		SEL_FOR_METHOD(@"animate",animate_key:value:duration:options:);
		SEL_FOR_METHOD(@"do",do_animationName:duration:);
		// inherited from abstract
		SEL_FOR_METHOD(@"callMethod",callMethod_method:);
		SEL_FOR_METHOD(@"wait",wait_duration:);
		SEL_FOR_METHOD(@"waitTap",waitTap);
		SEL_FOR_METHOD(@"waitText",waitText);
		SEL_FOR_METHOD(@"waitAnimation",waitAnimation);
		SEL_FOR_METHOD(@"set",set_key:value:);
		SEL_FOR_METHOD(@"enable",enable_key:enable:);
		SEL_FOR_METHOD(@"alias",alias_alias:method:);
		SEL_FOR_METHOD(@"new",new_args:);

	}


    return nil;
}

@end

