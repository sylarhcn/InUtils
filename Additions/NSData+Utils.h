//
//  NSData+Utils.h
//  InChengdu20
//
//  Created by aaron on 3/21/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utils)
/**
 * Calculate the md5 hash of this data using CC_MD5.
 *
 * @return md5 hash of this data
 */
- (NSString*)md5Hash;

/**
 * Calculate the SHA1 hash of this data using CC_SHA1.
 *
 * @return SHA1 hash of this data
 */
- (NSString*)sha1Hash;


/**
 * Create an NSData from a base64 encoded representation
 * Padding '=' characters are optional. Whitespace is ignored.
 * @return the NSData object
 */
+ (id)dataWithBase64EncodedString:(NSString *)string;

/**
 * Marshal the data into a base64 encoded representation
 *
 * @return the base64 encoded string
 */
- (NSString *)base64Encoding;
@end
