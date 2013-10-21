//
//  DataStore.h
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

@interface DataStore : NSObject {
    NSUserDefaults      *m_dataStore;
}

- (NSString*)userIdentifier;

- (id)dataForKey:(NSString *)key;
- (void)setData:(id)data forKey:(NSString *)key;
- (void)removeDataForKey:(NSString *)key;

- (BOOL)boolDataForKey:(NSString *)key;
- (void)setBoolData:(BOOL)data forKey:(NSString *)key;

- (NSInteger)integerDataForKey:(NSString *)key;
- (void)setIntegerData:(NSInteger)data forKey:(NSString *)key;

- (CGFloat)floatDataForKey:(NSString *)key;
- (void)setFloatData:(CGFloat)data forKey:(NSString *)key;

- (NSString *)stringDataForKey:(NSString *)key;
- (void)setStringData:(NSString *)data forKey:(NSString *)key;

- (NSDate *)dateDataForKey:(NSString *)key;
- (void)setDateData:(NSDate *)data forKey:(NSString *)key;

- (id)jsonDataForKey:(NSString *)key type:(Class)type;
- (void)setJsonData:(id)data forKey:(NSString *)key;

@end
