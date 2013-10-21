//
//  ServiceResult.h
//  inchengdu
//
//  Created by aaronzhou on 13-6-17.
//  Copyright (c) 2013年 joyotime. All rights reserved.
//

typedef enum {
    ErrorTypeSystem,
    ErrorTypeBusiness
} ErrorType;

@interface ServiceError : NSObject

@property(nonatomic,assign) ErrorType   type;
@property(nonatomic,assign) NSInteger   code;
@property(nonatomic,strong) NSString    *message;

@end

@interface ServiceResult : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, strong) ServiceError *error;

+ (ServiceResult*)resultWithJsonString:(NSString*)jsonString forDataType:(Class)dataType;
+ (ServiceResult*)resultWithErrorType:(ErrorType)type errorMessage:(NSString*)errorMessage statusCode:(NSInteger)statusCode;

@end
