//
//  UILabel+Utils.h
//  InChengdu20
//
//  Created by 昌宁 胡 on 12-3-21.
//  Copyright (c) 2012年 joyotime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Utils)
-(void)autoWidth:(CGSize)rangeSize line:(NSInteger)line;

-(void)autoHeight:(CGSize)rangeSize line:(NSInteger)line;

-(void)autoSize:(CGSize)rangeSize;
@end
