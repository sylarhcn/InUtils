//
//  UIScrollView+Utils.m
//  INCDUtils
//
//  Created by aaron on 2/3/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "UIScrollView+Utils.h"
#import "UIView+Utils.h"

@implementation UIScrollView (Utils)

//- (BOOL)noLoadMoreFooter{}
//- (void)setNoLoadMoreFooter:(BOOL)noLoadMoreFooter{}
//- (BOOL)noRefreshHeader{}
//- (void)setNoRefreshHeader:(BOOL)noRefreshHeader{}
//-(BOOL)noShowBackToTop{}
//- (void)setNoShowBackToTop:(BOOL)noShowBackToTop{} 

- (void)adjustFrameWhenKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    keyboardFrame = [keyWindow convertRect:keyboardFrame toView:self.superview];
    
    CGRect viewFrame = self.frame;
    
    if (keyboardFrame.origin.y > viewFrame.origin.y) {
        CGFloat offset = viewFrame.origin.y + viewFrame.size.height - keyboardFrame.origin.y;
        
        viewFrame.size.height -= offset;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:animationCurve];
        [UIView setAnimationDuration:animationDuration];
        self.frame = viewFrame;
        [self scrollRectToVisible:self.firstResonder.frame animated:YES];
        [UIView commitAnimations];
    }
}

@end
