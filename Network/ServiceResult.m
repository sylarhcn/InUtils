//
//  ServiceResult.m
//  inchengdu
//
//  Created by aaronzhou on 13-6-17.
//  Copyright (c) 2013年 joyotime. All rights reserved.
//

#import "ServiceResult.h"
#import "JSONKit.h"
#import "NSObject+JSON.h"

@implementation ServiceError

@end

@implementation ServiceResult

+ (ServiceResult *)resultWithJsonString:(NSString *)jsonString forDataType:(Class)dataType {
    ServiceResult *result = nil;
    NSError *error = nil;
    if (jsonString == nil) {
        return result;
    }
    id json = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionStrict|
               JKParseOptionLooseUnicode | JKParseOptionUnicodeNewlines error:&error];
    
    if (error) {
        result = [ServiceResult resultWithErrorType:ErrorTypeSystem
                                       errorMessage:[error localizedDescription]
                                         statusCode:0];
    }
    else {
        result = [[ServiceResult alloc] init];
        if (dataType) {
            result.data = [dataType dataModelWithJSONObject:json];
        }
        else {
            result.data = json;
        }
    }
    return result;
}

+ (ServiceResult *)resultWithErrorType:(ErrorType)type errorMessage:(NSString *)errorMessage statusCode:(NSInteger)statusCode {
    ServiceError *error = [[ServiceError alloc] init];
    error.type = type;
    error.code = statusCode;
    error.message = errorMessage;
    
    ServiceResult *result = [[ServiceResult alloc] init];
    result.data = nil;
    result.error = error;
    
    return result;
}

@end
