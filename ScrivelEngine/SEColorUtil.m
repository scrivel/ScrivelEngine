//
//  SEColorUtil.m
//  ScrivelEngine
//
//  Created by keroxp on 2014/02/27.
//  Copyright (c) 2014年 scrivel. All rights reserved.
//

#import "SEColorUtil.h"

@implementation SEColorUtil

+ (SEColor *)colorWithHEXString:(NSString *)hexadecimal
{
	// convert Objective-C NSString to C string
    NSString *_hexadesimal = hexadecimal;
    // remove '#' prefix
    if([hexadecimal characterAtIndex:0] == '#'){
        _hexadesimal = [hexadecimal substringFromIndex:1];
    }
    // 1 => 111111
    if (_hexadesimal.length == 1) {
        _hexadesimal = [NSString stringWithFormat:@"%@%@%@%@%@%@",_hexadesimal,_hexadesimal,_hexadesimal,_hexadesimal,_hexadesimal,_hexadesimal];
    }
    // 333 or 333333
    if (_hexadesimal.length == 3) {
        _hexadesimal = [NSString stringWithFormat:@"%@%@",_hexadesimal,_hexadesimal];
    }
    // get rgba components
    const char *hex;
    unsigned long red, green, blue, alpha;
    for (unsigned int i = 0, max = (_hexadesimal.length == 8) ? 4 : 3; i < max; i++) {
        hex =[[_hexadesimal substringWithRange:NSMakeRange(i, 2)] cStringUsingEncoding:NSASCIIStringEncoding];
        switch (i) {
            case 0:
                red = strtol(hex, NULL, 16);
                break;
            case 1:
                green = strtol(hex, NULL, 16);
                break;
            case 2:
                blue = strtol(hex, NULL, 16);
                break;
            case 3:
                alpha = strtol(hex, NULL, 16);
                break;
            default:
                break;
        }
    }
    SEColor *color = nil;
    if (_hexadesimal.length == 8) {
        color = [SEColor colorWithRed:(CGFloat)red/255.0f green:(CGFloat)green/255.0f blue:(CGFloat)blue/255.0f alpha:(CGFloat)alpha/255.0f];
    }else if(_hexadesimal.length == 6){
        color = [SEColor colorWithRed:(CGFloat)red/255.0f green:(CGFloat)green/255.0f blue:(CGFloat)blue/255.0f alpha:1.0f];
    }
    return color;
}

@end