//
//  INConnection.h
//  HCNDemo
//
//  Created by Nick Hu on 13-8-21.
//  Copyright (c) 2013年 Nick Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ServiceResult.h"
@class INConnection;
@protocol INConnectionDelegate <NSObject>
@optional
- (void)inConnectionDidStarted:(INConnection *)connection;
- (void)inConnectionDidFinished:(INConnection *)connection result:(ServiceResult *)result;
- (void)inConnectionDidFailed:(INConnection *)connection result:(ServiceResult *)result;
- (void)inConnectionDidCanceled:(INConnection *)connection;
@end
@interface INConnection : NSObject

@property (nonatomic,assign) id<INConnectionDelegate> delegate;

@property (nonatomic,strong) ASIHTTPRequest *request;

- (id)initWithDelegate:(id)delegate;

- (void)getWithURL:(NSString *)url
          dataType:(Class)dataType needAuth:(BOOL)auth;

- (void)postWithURL:(NSString *)url
           formData:(NSDictionary *)formData
           dataType:(Class)dataType needAuth:(BOOL)auth;

- (void)postWithURL:(NSString *)url
           formData:(NSDictionary *)formData
         uploadFile:(NSData*)uploadFile
           dataType:(Class)dataType needAuth:(BOOL)auth;

- (void)cancel;


@end
