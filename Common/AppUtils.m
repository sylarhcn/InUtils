//
//  AppUtils.m
//  InChengdu20
//
//  Created by aaron on 1/31/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "AppUtils.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "OpenUDID.h"

@implementation AppUtils

+ (NSString *)deviceType {
    return [[UIDevice currentDevice] model];
}

+ (NSString*)iOSVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString*)appDisplayName {
    NSString *result = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
    return result;
}

+ (NSString*)appVersion {
#ifdef DEBUG
    NSString *result = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
#else
    NSString *result = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
#endif
    
    return result;
}

+ (NSString*)deviceCode {
//    UIDevice *device = [UIDevice currentDevice];
//    return [device uniqueIdentifier];
    NSString *code = [OpenUDID value];
//    LOG(@"Device Code: %@", code);
    return code;
}

+ (NSString *)generateUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}


+ (NSString *)platformString {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 CDMA";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 WiFi";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 GSM";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 CDMA";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 CDMAS";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini Wifi";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 CDMA";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 GSM";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 Wifi";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

+ (NSString*)macAddress {
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;              
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) 
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    // Read from char array into a string object, into traditional Mac address format
    NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                                  macAddress[0], macAddress[1], macAddress[2], 
                                  macAddress[3], macAddress[4], macAddress[5]];
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSString*)getCurrentTimestampMultiplyMillion
{
    @synchronized(self)
    {
        double interval = 1000000.0 * [[NSDate date] timeIntervalSince1970];
        return [NSString stringWithFormat:@"%0.0f", interval];
    }
}

+ (BOOL)isVersionA:(NSString*)verA higherThanVersionB:(NSString*)verB {
    NSArray *arrayA = [verA componentsSeparatedByString:@"."];
    NSArray *arrayB = [verB componentsSeparatedByString:@"."];
    
    NSUInteger count = MAX([arrayA count], [arrayB count]);
    for (int i = 0; i < count; i++) {
        NSInteger a = 0, b = 0;
        
        if (i < [arrayA count]) {
            a = [[arrayA objectAtIndex:i] intValue];
        }
        if (i < [arrayB count]) {
            b = [[arrayB objectAtIndex:i] intValue];
        }
        
        if (a > b) {
            return YES;
        }
        if (a < b) {
            return NO;
        }
    }
    return NO;
}

+ (BOOL)isVersionA:(NSString*)verA higherOrEqualVersionB:(NSString*)verB {
    
    if ([verA isEqualToString:verB])
    {
        return YES;
    }
    
    NSArray *arrayA = [verA componentsSeparatedByString:@"."];
    NSArray *arrayB = [verB componentsSeparatedByString:@"."];
    
    NSUInteger count = MAX([arrayA count], [arrayB count]);
    for (int i = 0; i < count; i++) {
        NSInteger a = 0, b = 0;
        
        if (i < [arrayA count]) {
            a = [[arrayA objectAtIndex:i] intValue];
        }
        if (i < [arrayB count]) {
            b = [[arrayB objectAtIndex:i] intValue];
        }
        
        if (a > b) {
            return YES;
        }
        if (a < b) {
            return NO;
        }
    }
    return NO;
}

+ (BOOL)hasNewVersion:(NSString *)compareVersion {
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"];
    NSString *serverVersion = (compareVersion==nil) ? @"" : compareVersion;
    
    return [AppUtils isVersionA:serverVersion higherThanVersionB:localVersion];
}

@end