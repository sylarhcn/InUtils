//
//  DataCache.h
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

@interface DataCache : NSObject {
    NSMutableDictionary *m_dataCache;
}

+ (DataCache *)sharedCache;

- (id)dataForKey:(NSString *)key;
- (void)setData:(id)data forKey:(NSString *)key;
- (void)removeDataForKey:(NSString *)key;

@end
