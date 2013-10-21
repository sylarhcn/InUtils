//
//  RuntimeFunctions.h
//  InChengdu20
//
//  Created by aaron on 7/12/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 * Swap the two method implementations on the given class.
 * Uses method_exchangeImplementations to accomplish this.
 */
void INSwapMethods(Class cls, SEL originalSel, SEL newSel);

void INSwapClassMethod(Class cls, SEL originalSel, SEL newSel);