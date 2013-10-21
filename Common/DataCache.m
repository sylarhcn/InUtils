//
//  DataCache.m
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "DataCache.h"

@implementation DataCache

#pragma mark - Singleton methods

static DataCache *s_dataCache = nil;

+ (DataCache *)sharedCache {
    if (s_dataCache == nil) {
        @synchronized(self) {
            if (s_dataCache == nil) {
                s_dataCache = [[DataCache alloc] init];
            }
        }
    }
    return s_dataCache;
}

#pragma mark - Initialization & Memory management methods

- (id)init 
{
    self = [super init];
    if (self) {
        m_dataCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Public property & method

- (id)dataForKey:(NSString *)key {
    id data = [m_dataCache objectForKey:key];
    
    return (data == [NSNull null]) ? nil : data;
}

- (void)setData:(id)data forKey:(NSString *)key {
    [m_dataCache setObject:data forKey:key];
}

- (void)removeDataForKey:(NSString *)key {
    [m_dataCache removeObjectForKey:key];
}

@end
