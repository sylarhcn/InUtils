//
//  INConnection.m
//  HCNDemo
//
//  Created by Nick Hu on 13-8-21.
//  Copyright (c) 2013年 Nick Hu. All rights reserved.
//

#import "INConnection.h"

@implementation INConnection
@synthesize delegate = _delegate;
@synthesize request = _request;

- (id)initWithDelegate:(id)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Request method

- (void)getWithURL:(NSString *)url dataType:(Class)dataType needAuth:(BOOL)auth{
    _request = [self requestWithURL:url httpMethod:@"GET" needAuth:auth];
    _request.delegate = self;
    __weak INConnection *weakSelf = self;
    [_request setCompletionBlock:^(){
        INConnection *con = weakSelf;
        if (con) {
            [con onRequestFinished:con.request dataType:dataType];
        }
        else {
//            NSAssert(NO, @"INConnection:%@ is nil now",con);
        }
    }];
    
    [_request setFailedBlock:^(){
        INConnection *con = weakSelf;
        if (con) {
            [con onRequestFailed:con.request];
        }
        else {
//            NSAssert(NO, @"%s INConnection:%@ is nil now",__FUNCTION__,con);
        }
    }];
    
    [_request setStartedBlock:^(){
        INConnection *con = weakSelf;
        if (con) {
            [con onRequestStarted:con.request];
        }
        else {
//            NSAssert(NO, @"%s INConnection:%@ is nil now",__FUNCTION__,con);
        }
    }];
    [_request startAsynchronous];
}

- (void)postWithURL:(NSString *)url formData:(NSDictionary *)formData dataType:(Class)dataType needAuth:(BOOL)auth{
    [self postWithURL:url formData:formData uploadFile:nil dataType:dataType needAuth:auth];
}

- (void)postWithURL:(NSString *)url formData:(NSDictionary *)formData uploadFile:(NSData *)uploadFile dataType:(Class)dataType needAuth:(BOOL)auth{
    
    _request = (ASIFormDataRequest*)[self requestWithURL:url httpMethod:@"POST" needAuth:auth];
    
    if (formData) {
        for (NSString *key in [formData allKeys]) {
            [(ASIFormDataRequest*)_request setPostValue:[formData valueForKey:key] forKey:key];
        }
    }
    if (uploadFile) {
        [(ASIFormDataRequest*)_request addData:uploadFile
            withFileName:[[self class] uploadFileName]
          andContentType:[[self class] uploadFileContentType]
                  forKey:[[self class] uploadFileKey]];
    }
    __weak INConnection *weakSelf = self;
    [_request setCompletionBlock:^(){
        INConnection *con = weakSelf;
        if (con) {
            [con onRequestFinished:con.request dataType:dataType];
        }
        else {
//            NSAssert(NO, @"INConnection:%@ is nil now",con);
        }
    }];
    
    [_request setFailedBlock:^(){
        INConnection *con = weakSelf;
        if (con) {
            [con onRequestFailed:con.request];
        }
        else {
//            NSAssert(NO, @"%s INConnection:%@ is nil now",__FUNCTION__,con);
        }
    }];
    
    [_request setStartedBlock:^(){
        INConnection *con = weakSelf;
        if (con) {
            [con onRequestStarted:con.request];
        }
        else {
//            NSAssert(NO, @"%s INConnection:%@ is nil now",__FUNCTION__,con);
        }
    }];
    
    [_request startAsynchronous];
}

- (void)cancel
{
    [_request clearDelegatesAndCancel];
    if ([_delegate respondsToSelector:@selector(inConnectionDidCanceled:)]) {
        [_delegate inConnectionDidCanceled:self];
    }
}

#pragma mark - Request Block

- (void)onRequestStarted:(ASIHTTPRequest *)request {
    if ([_delegate respondsToSelector:@selector(inConnectionDidStarted:)]) {
        [_delegate inConnectionDidStarted:self];
    }
}

- (void)onRequestFinished:(ASIHTTPRequest *)request dataType:(Class)dataType {
    
    ServiceResult *result = nil;
    NSLog(@"%@------------------->",request.url);
    NSLog(@"%@",request.responseString);
    NSLog(@"%@",[request.responseStatusMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    switch (request.responseStatusCode) {
        case 200:
            result = [ServiceResult resultWithJsonString:request.responseString forDataType:dataType];
            result.error = nil;
            break;
        case 304:
            //304不处理
            break;
        case 403: // Forbidden: we understand your request, but are refusing to fulfill it.  An accompanying error message should explain why.
        case 401:
        case 400: // Bad Request: your request is invalid, and we'll return an error message that tells you why. This is the status code returned if you've exceeded the rate limit
        case 404: // Not Found: either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user).
        case 407: // Proxy authentication required
        case 500: // Internal Server Error: we did something wrong.  Please post to the group about it and the Twitter team will investigate.
        case 502: // Bad Gateway: returned if Twitter is down or being upgraded.
        case 503: // Service Unavailable: the Twitter servers are up, but are overloaded with requests.  Try again later.
        default: {
            result = [ServiceResult resultWithErrorType:ErrorTypeSystem
                                           errorMessage:[request.responseStatusMessage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                             statusCode:request.responseStatusCode];
            
            break;
        }
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^(){
        if (result.error == nil) {
            if ([_delegate respondsToSelector:@selector(inConnectionDidFinished:result:)]) {
                 [_delegate inConnectionDidFinished:self result:result];
            }
        }
        else {
            if ([_delegate respondsToSelector:@selector(inConnectionDidFailed:result:)]) {
                [_delegate inConnectionDidFailed:self result:result];
            }
        }
        
    });
}

- (void)onRequestFailed:(ASIHTTPRequest *)request{
    NSInteger code = request.error.code;
    NSString *msg = [request.error localizedDescription];
    ServiceResult *result = [ServiceResult resultWithErrorType:ErrorTypeSystem errorMessage:msg statusCode:code];
    if ([_delegate respondsToSelector:@selector(inConnectionDidFailed:result:)]) {
        [_delegate inConnectionDidFailed:self result:result];
    }
    [request clearDelegatesAndCancel];
}

- (ASIHTTPRequest *)requestWithURL:(NSString *)url httpMethod:(NSString *)httpMethod needAuth:(BOOL)auth {
    __autoreleasing ASIHTTPRequest *request;
    if ([httpMethod isEqualToString:@"GET"]) {
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [request setRequestMethod:httpMethod];
    }
    else {
        request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    }
    request.timeOutSeconds = [self timeoutTimeInterval];
    request.numberOfTimesToRetryOnTimeout = [self retryTimes];
    return [self makeRequestHeader:request];
}

#pragma mark - UploadFile Relation

- (NSString *)uploadFileName {
    return @"fileName";
}

- (NSString *)uploadFileKey {
    return @"fileKey";
}

- (NSString *)uploadFileContentType {
    return @"application/octet-stream";
}

#pragma mark - customMethod

- (NSTimeInterval)timeoutTimeInterval
{
    return 45;
}

- (NSInteger)retryTimes
{
    return 0;
}

- (ASIHTTPRequest *)makeRequestHeader:(ASIHTTPRequest *)request
{
    
    return request;
}
@end
