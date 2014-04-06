//
//  SEBasicCharacterLayer.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/03/10.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEBasicCharacterLayer.h"
#import "SEBasicApp.h"
#import "NSValue+ScrivelEngine.h"

#define kDefaultDuration 0.25
#define kDefaultFrom @"left"
#define kDefaultTo @"right"

@implementation SEBasicCharacterLayerClass
{
    NSMutableDictionary *__definedMotions;
    NSMutableDictionary *__markedPoints;
}

@synthesize definedMotions = __definedMotions;
@synthesize markedPoints = __markedPoints;

- (instancetype)initWithEngine:(ScrivelEngine *)engine classIdentifier:(NSString *)classIdentifier
{
    self = [super initWithEngine:engine classIdentifier:classIdentifier];
    __definedMotions = [NSMutableDictionary new];
    __markedPoints = [NSMutableDictionary new];
    return self ?: nil;
}

- (Class)instanceClass
{
    return [SEBasicCharacterLayer class];
}

- (void)mark_key:(id<NSCopying>)key point:(id)point
{
    SEPoint _point = SEPointFromObject(self.engine.rootView.bounds.size, point);
    [__markedPoints setObject:[NSValue se_valueWithPoint:_point] forKey:[key copyWithZone:NULL]];
}

- (void)defineMotion_name:(NSString *)name
{

}

@end

@implementation SEBasicCharacterLayer

- (void)defineExpression_name:(NSString *)name imagePath:(NSString *)imagePath
{

}

- (void)express_name:(NSString *)name duration:(NSTimeInterval)duration
{

}

- (void)exit_info:(NSDictionary *)info
{
    NSString *to = info[@"to"] ?: kDefaultTo;
    CFTimeInterval duration = [info[@"duration"] doubleValue] ?:kDefaultDuration;

    SEPoint top;
    if ([to isEqualToString:@"right"]) {
        top.x = CGRectGetWidth(self.layer.bounds) + CGRectGetWidth(self.layer.bounds)*self.layer.anchorPoint.x;
        top.y = self.layer.position.y;
    }else if ([to isEqualToString:@"left"]){
        top.x = - CGRectGetWidth(self.layer.bounds)*(1-self.layer.anchorPoint.x);
        top.y = self.layer.position.y;
    }else if ([to isEqualToString:@"top"]){
        top.x = self.layer.position.x;
        top.y = CGRectGetHeight(self.layer.bounds) + CGRectGetHeight(self.layer.bounds)*self.layer.anchorPoint.y;
    }else if ([to isEqualToString:@"bottom"]){
        top.x = self.layer.position.x;
        top.y = - CGRectGetHeight(self.layer.bounds)*(1-self.layer.anchorPoint.y);
    }
    [self animate_animations:@{@"position": [NSValue se_valueWithPoint:top]} options:@{@"duration": @(duration)}];
}

- (void)appear_info:(NSDictionary *)info
{
    id<NSCopying> at = info[@"at"];
    if (!at) return;

    NSString *from = info[@"from"] ?: kDefaultFrom;
    CFTimeInterval duration = [info[@"duration"] doubleValue] ?: kDefaultDuration;

    SEPoint marked = [[(SEBasicCharacterLayerClass*)self.holder markedPoints][at] se_pointValue];
    SEPoint fromp;
    if ([from isEqualToString:@"left"]) {
        fromp.x = - CGRectGetWidth(self.layer.bounds)*(1-self.layer.anchorPoint.x);
        fromp.y = marked.y;
    }else if ([from isEqualToString:@"right"]){
        fromp.x = VIEW_SIZE.width + CGRectGetWidth(self.layer.bounds)*self.layer.anchorPoint.x;
        fromp.y = marked.y;
    }else if ([from isEqualToString:@"top"]){
        fromp.x = marked.x;
        fromp.y = VIEW_SIZE.height + CGRectGetHeight(self.layer.bounds)*self.layer.anchorPoint.y;
    }else if ([from isEqualToString:@"bottom"]){
        fromp.x = marked.x;
        fromp.y = - CGRectGetHeight(self.layer.bounds)*(1-self.layer.anchorPoint.y);
    }
    self.layer.position = fromp;
    [self animate_animations:@{@"position": [NSValue se_valueWithPoint:marked]} options:@{@"duration": @(duration)}];
    [self waitAnimation];
}

- (void)motion_name:(NSString *)name options:(NSDictionary *)options
{
    NSString *key = name;
    if (KEY_IS(@"jump")) {
        [self jumpWithOptions:options];
    }else if (KEY_IS(@"shake")){
        [self shakeWithOptions:options];
    }
}

- (void)jumpWithOptions:(NSDictionary*)options
{

}

- (void)shakeWithOptions:(NSDictionary*)options
{

}


@end
