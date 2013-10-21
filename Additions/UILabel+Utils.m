//
//  UILabel+Utils.m
//  InChengdu20
//
//  Created by 昌宁 胡 on 12-3-21.
//  Copyright (c) 2012年 joyotime. All rights reserved.
//

#import "UILabel+Utils.h"
#import "UIView+Utils.h"
@implementation UILabel (Utils)

-(void)autoWidth:(CGSize)rangeSize line:(NSInteger)line
{
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, 0, self.frame.size.height);
    [self setNumberOfLines:line];
    NSString *s = self.text;
    UIFont *font = self.font;
    CGSize size = rangeSize;
    int lineMode = UILineBreakModeTailTruncation;
    if (iOS7) {
        lineMode = NSLineBreakByTruncatingTail;
    }
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:lineMode];
    self.frame =  CGRectMake(self.frame.origin.x,self.frame.origin.y, labelsize.width,self.frame.size.height);
    if (iOS7) {
        [self autoSize:rangeSize];
        self.numberOfLines = line;
        self.sizeH = rangeSize.height;
    }
}

-(void)autoHeight:(CGSize)rangeSize line:(NSInteger)line
{
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, 0);
    [self setNumberOfLines:line];
    NSString *s = self.text;
    UIFont *font = self.font;
    CGSize size = rangeSize;
    int lineMode = UILineBreakModeTailTruncation;
    if (iOS7) {
        lineMode = NSLineBreakByTruncatingTail;
    }
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:lineMode];
    self.frame =  CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, labelsize.height);
    if (iOS7) {
        [self autoSize:rangeSize];
        self.numberOfLines = line;
        self.sizeW = rangeSize.width;
    }
}

-(void)autoSize:(CGSize)rangeSize
{
    self.numberOfLines = 0;
    CGSize tsize = [self sizeThatFits:rangeSize];
    CGRect trct = self.frame;
    trct.size = tsize;
    self.frame = trct;
}
@end
