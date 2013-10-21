//
//  NSObject+JSON.h
//  INCDFramework
//
//  Created by aaron on 2/3/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

@interface NSObject (JSON)

+ (id)dataModelWithJSONString:(NSString *)jsonString;
+ (id)dataModelWithJSONObject:(id)jsonObject;

- (void)fillWithJSONObejct:(NSDictionary *)jsonObject;

- (NSString *)toJSONString;
- (NSDictionary *)toJSONObject;

@end
