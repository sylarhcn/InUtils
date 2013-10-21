//
//  UIScrollView+Utils.h
//  INCDUtils
//
//  Created by aaron on 2/3/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

@interface UIScrollView (Utils)
//@property (assign,nonatomic) BOOL noRefreshHeader;//是不是不需要刷新
//@property (assign,nonatomic) BOOL noLoadMoreFooter;//是不是不需要加载
//@property (assign,nonatomic) BOOL noShowBackToTop;//是不是不需要返回顶部
- (void)adjustFrameWhenKeyboardWillShowNotification:(NSNotification *)notification;

@end
