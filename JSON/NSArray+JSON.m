//
//  NSArray+JSON.m
//  InChengdu20
//
//  Created by aaron on 1/30/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "NSArray+JSON.h"
#import "JSONKit.h"
#import "NSObject+JSON.h"
@implementation NSArray (JSON)

- (NSString *)_toJSONString {
    NSArray *jsonObject = [self _toJSONObject];
    NSError *error = nil;
    NSString *jsonString = [jsonObject JSONStringWithOptions:JKSerializeOptionNone error:&error];
    
    return jsonString;
}

- (NSArray *)_toJSONObject {
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    for (id item in self) {
        id value = nil;
        if ([item isKindOfClass:[NSString class]]) {
            value = item;
        } else if ([item isKindOfClass:[NSNumber class]]) {
            value = item;
        } else if ([item isKindOfClass:[NSNull class]]) {
            value = item;
        } else if ([item isKindOfClass:[NSArray class]]) {
            value = [(NSArray *)item _toJSONObject];
        } else {
            value = [item toJSONObject];
        }

        [jsonArray addObject:value];
    }
    
    return jsonArray;
}

@end
