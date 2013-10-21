//
//  UIImage+Utils.h
//  InChengdu20
//
//  Created by 昌宁 胡 on 12-4-9.
//  Copyright (c) 2012年 joyotime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageByShareToWeiXin;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
