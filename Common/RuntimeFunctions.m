//
//  RuntimeFunctions.m
//  InChengdu20
//
//  Created by aaron on 7/12/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "RuntimeFunctions.h"
#import <objc/runtime.h>

///////////////////////////////////////////////////////////////////////////////////////////////////
void INSwapMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

void INSwapClassMethod(Class cls, SEL originalSel, SEL newSel)
{
    Method origMethod = class_getClassMethod(cls, originalSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    
    cls = object_getClass((id)cls);
    
    if(class_addMethod(cls,
                       originalSel,
                       method_getImplementation(newMethod),
                       method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(cls,
                            newSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}
