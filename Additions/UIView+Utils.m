//
//  UIView+Utils.m
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "UIView+Utils.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (Utils)

- (CGPoint)origin {
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    
    frame.origin = origin;
    
    self.frame = frame;
}

- (CGFloat)originX {
    return self.frame.origin.x;
}
- (void)setOriginX:(CGFloat)originX {
    CGRect frame = self.frame;
    
    frame.origin.x = originX;
    
    self.frame = frame;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}
- (void)setOriginY:(CGFloat)originY {
    CGRect frame = self.frame;
    
    frame.origin.y = originY;
    
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    
    frame.size = size;
    
    self.frame = frame;
}

- (CGFloat)sizeW {
    return self.frame.size.width;
}
- (void)setSizeW:(CGFloat)sizeW {
    CGRect frame = self.frame;
    
    frame.size.width = sizeW;
    
    self.frame = frame;
}

- (CGFloat)sizeH {
    return self.frame.size.height;
}

- (void)setSizeH:(CGFloat)sizeH {
    CGRect frame = self.frame;
    
    frame.size.height = sizeH;
    
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (UIImage *)screenshot {
    
    if (UIGraphicsBeginImageContextWithOptions != nil) 
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size,self.opaque,[[UIScreen mainScreen] scale]);
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[[UIScreen mainScreen] scale]);
    }
    else 
    {
        UIGraphicsBeginImageContext(self.bounds.size);
    }
    
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	[self.layer renderInContext:ctx];
    
	UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
	
	return anImage;
}

- (UIView *)firstResonder
{
    if (self.isFirstResponder) {        
        return self;     
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = subView.firstResonder;
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;     
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}

- (BOOL)hasFirstRespondor{
	if( self.isFirstResponder ){
		return YES;
	}
	
	for( UIView *subView in self.subviews ){
		if( [subView hasFirstRespondor] ){
			return YES;
		}
	}
	
	return NO;
}

@end
