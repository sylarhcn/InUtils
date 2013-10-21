//
//  AppUtils.h
//  InChengdu20
//
//  Created by aaron on 1/31/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>

@interface AppUtils : NSObject

+ (NSString*)deviceType;

+ (NSString*)iOSVersion;

+ (NSString*)appDisplayName;

+ (NSString*)appVersion;

+ (NSString*)deviceCode;

+ (NSString *)platformString;

+ (NSString*)macAddress;

+ (NSString*)generateUUID;

+ (NSString*)getCurrentTimestampMultiplyMillion;

+ (BOOL)isVersionA:(NSString*)verA higherThanVersionB:(NSString*)verB;
+ (BOOL)isVersionA:(NSString*)verA higherOrEqualVersionB:(NSString*)verB;

+ (BOOL)hasNewVersion:(NSString *)compareVersion;
@end

void PlaySound(NSString *name, NSString *type);
void PlaySoundFinished(SystemSoundID soundID, void *data);
