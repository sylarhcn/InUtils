//
//  DataStore.m
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "DataStore.h"
#import "NSObject+JSON.h"

@implementation DataStore
#pragma mark - Initialization & Memory management methods

- (id)init {
    self = [super init];
    if (self) {
        m_dataStore = [[NSUserDefaults alloc] init];
    }
    return self;
}


- (NSString*)userIdentifier {
    NSAssert(YES, @"You must overide this method in subclass!!!" );
    
    return nil;
}

#pragma mark - Public property & method
- (NSString*)genGroupKey:(NSString*)key {
    return [NSString stringWithFormat:@"%@_%@", self.userIdentifier, key];
}

- (id)dataForKey:(NSString *)key {
    id data = [m_dataStore objectForKey:[self genGroupKey:key]];
    return data == [NSNull null] ? nil :data;
}

- (void)setData:(id)data forKey:(NSString *)key {
    [m_dataStore setObject:data forKey:[self genGroupKey:key]];
    [m_dataStore synchronize];
}

- (void)removeDataForKey:(NSString *)key {
    [m_dataStore removeObjectForKey:[self genGroupKey:key]];
    [m_dataStore synchronize];
}

- (BOOL)boolDataForKey:(NSString *)key {
    BOOL data = [m_dataStore boolForKey:[self genGroupKey:key]];
    
    return data;    
}
- (void)setBoolData:(BOOL)data forKey:(NSString *)key {
    [m_dataStore setBool:data forKey:[self genGroupKey:key]];
    [m_dataStore synchronize];    
}

- (NSInteger)integerDataForKey:(NSString *)key {
    NSInteger data = [m_dataStore integerForKey:[self genGroupKey:key]];
    return data;    
}

- (void)setIntegerData:(NSInteger)data forKey:(NSString *)key {
    [m_dataStore setInteger:data forKey:[self genGroupKey:key]];
    [m_dataStore synchronize];    
}

- (CGFloat)floatDataForKey:(NSString *)key {
    CGFloat data = [m_dataStore floatForKey:[self genGroupKey:key]];
    
    return data;    
}
- (void)setFloatData:(CGFloat)data forKey:(NSString *)key {
    [m_dataStore setFloat:data forKey:[self genGroupKey:key]];
    [m_dataStore synchronize];    
}

- (NSString *)stringDataForKey:(NSString *)key {
    NSString *data = [m_dataStore stringForKey:[self genGroupKey:key]];

    return data;    
}

- (void)setStringData:(NSString *)data forKey:(NSString *)key {
    [m_dataStore setValue:data forKey:[self genGroupKey:key]];
    [m_dataStore synchronize];    
}

- (NSDate *)dateDataForKey:(NSString *)key {
    NSDate *data = (NSDate*)[m_dataStore dataForKey:[self genGroupKey:key]];
    
    return data;  
}

- (void)setDateData:(NSDate *)data forKey:(NSString *)key {
    [m_dataStore setValue:data forKey:[self genGroupKey:key]];
    [m_dataStore synchronize];
}

- (id)jsonDataForKey:(NSString *)key type:(Class)type {
    id data = nil;
    
    NSString *json = [m_dataStore stringForKey:[self genGroupKey:key]];
    
    if (json != nil) {
        data = [type dataModelWithJSONString:json];
    }
    
    return data;
}

- (void)setJsonData:(id)data forKey:(NSString *)key {
    NSString *json = nil;
    
    if (data != nil) {
        json = [data toJSONString];
    }
    
    [m_dataStore setObject:json forKey:[self genGroupKey:key]];
    [m_dataStore synchronize];
}


@end
