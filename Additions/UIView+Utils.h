//
//  UIView+Utils.h
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

@interface UIView (Utils)

@property(nonatomic,assign) CGPoint origin;
@property(nonatomic,assign) CGFloat originX;
@property(nonatomic,assign) CGFloat originY;
@property(nonatomic,assign) CGSize  size;
@property(nonatomic,assign) CGFloat  sizeW;
@property(nonatomic,assign) CGFloat  sizeH;
@property(nonatomic,assign) CGFloat  centerX;
@property(nonatomic,assign) CGFloat  centerY;

- (UIImage *)screenshot;

- (UIView*)firstResonder;
- (BOOL)findAndResignFirstResponder;
- (BOOL)hasFirstRespondor;
@end
