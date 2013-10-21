//
//  CoreMacros.h
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#ifndef InChengdu20_CoreMacros_h
#define InChengdu20_CoreMacros_h

///////////////////////////////////////////////////////////////////////////////////////////////////
// Time

#define MINUTE 60
#define HOUR   (60 * NE_MINUTE)
#define DAY    (24 * NE_HOUR)
#define WEEK   (7 * NE_DAY)
#define MONTH  (30.5 * NE_DAY)
#define YEAR   (365 * NE_DAY)

///////////////////////////////////////////////////////////////////////////////////////////////////
// Safe releases
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
#define RELEASE_SERVICE_SAFELY(__SERVICE){[__SERVICE cancel];__SERVICE.target = nil;[__SERVICE release];__SERVICE=nil;}

// Release a CoreFoundation object safely.
#define IN_RELEASE_CF_SAFELY(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }

///////////////////////////////////////////////////////////////////////////////////////////////////
// Color helpers

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HSVCOLOR(h,s,v) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:1]
#define HSVACOLOR(h,s,v,a) [UIColor colorWithHue:(h) saturation:(s) value:(v) alpha:(a)]

#endif

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOS7 ([[[UIDevice currentDevice] systemVersion] intValue]==7)