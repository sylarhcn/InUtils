//
//  NSObject+Utils.m
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "NSObject+Utils.h"
#import <objc/runtime.h>

@implementation NSObject (Utils)

-(id)instanceVariableForKey:(NSString *)aKey {
    Ivar ivar = class_getInstanceVariable([self class], [aKey UTF8String]);
    return object_getIvar(self, ivar);
}

@end