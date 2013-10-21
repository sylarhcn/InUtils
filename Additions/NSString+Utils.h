//
//  NSString+Utils.h
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

@interface NSString (Utils)

+ (id)stringWithUTF8StringExceptNULL:(const char *)nullTerminatedCString;

- (BOOL)hasNonWhitespaceText;

- (BOOL)isEqualToStringIgnoreCase:(NSString*)str;

- (BOOL)isNumeric;

- (NSInteger)intValueWithDefaultZero;

- (NSString *)stringByTrimming;
//- (NSInteger)stringLengthWithUTF8String;

- (NSString *)urlQueryStringValueEncodeUsingUTF8Encoding;
- (NSString *)urlQueryStringValueEncodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)urlQueryStringValueDecodeUsingUTF8Encoding;
- (NSString *)urlQueryStringValueDecodeUsingEncoding:(NSStringEncoding)encoding;

- (NSString *)appendQueryStringKey:(NSString*)key andFloatValue:(CGFloat)value;
- (NSString *)appendQueryStringKey:(NSString*)key andIntValue:(NSInteger)value;
- (NSString *)appendQueryStringKey:(NSString*)key andStringValue:(NSString*)value;
/**
 * Calculate the md5 hash of this string using CC_MD5.
 *
 * @return md5 hash of this string
 */
- (NSString*)md5Hash;

/**
 * Calculate the SHA1 hash of this string using CommonCrypto CC_SHA1.
 *
 * @return NSString with SHA1 hash of this string
 */
- (NSString*)sha1Hash;

#pragma mark - Regex
- (BOOL) isEmail;
- (NSString *)escapeHTML;
- (NSString *)unescapeHTML;
- (NSString*)stringByRemovingHTML;
@end
