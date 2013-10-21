//
//  DeviceUtils.m
//  InChengdu20
//
//  Created by aaron on 1/31/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "DeviceUtils.h"
#import <sys/utsname.h>

@implementation DeviceUtils

+ (BOOL)isSingleTask {
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	} else {
		return NO;
	}
}

@end
