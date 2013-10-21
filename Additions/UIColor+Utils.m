//
//  UIColor+Utils.m
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor *)colorWithHex:(NSString *)hexColor {
    hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([hexColor length] < 6) {
        return nil;
    }
    
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    NSString *rs = [hexColor substringWithRange:range];
    
    range.location = 2;
    NSString *gs = [hexColor substringWithRange:range];
    
    range.location = 4;
    NSString *bs = [hexColor substringWithRange:range];
    
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rs] scanHexInt:&r];
    [[NSScanner scannerWithString:gs] scanHexInt:&g];
    [[NSScanner scannerWithString:bs] scanHexInt:&b];
    
    if ([hexColor length] == 8) {
        range.location = 4;
        NSString *as = [hexColor substringWithRange:range];
        [[NSScanner scannerWithString:as] scanHexInt:&a];
    } else {
        a = 255;
    }
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
}

@end
