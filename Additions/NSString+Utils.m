//
//  NSString+Utils.m
//  InChengdu20
//
//  Created by aaron on 1/29/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

#import "NSString+Utils.h"
#import "NSData+Utils.h"

@implementation NSString (Utils)

+ (id)stringWithUTF8StringExceptNULL:(const char *)nullTerminatedCString {
    if (nullTerminatedCString==NULL) {
        return nil;
    }
    else {
        return [NSString stringWithUTF8String:nullTerminatedCString];
    }
}

- (BOOL)hasNonWhitespaceText {
    return [self stringByTrimming].length > 0;
}

- (BOOL)isEqualToStringIgnoreCase:(NSString*)str {
    return [[self lowercaseString] isEqualToString:[str lowercaseString]];
}

- (BOOL)isNumeric {
    
    NSScanner *sc = [NSScanner scannerWithString: self];
    // We can pass NULL because we don't actually need the value to test
    // for if the string is numeric. This is allowable.
    if ( [sc scanFloat:NULL] )
    {
        // Ensure nothing left in scanner so that "42foo" is not accepted.
        // ("42" would be consumed by scanFloat above leaving "foo".)
        return [sc isAtEnd];
    }
    // Couldn't even scan a float :(
    return NO;
}

- (NSInteger)intValueWithDefaultZero {
    if ([self isNumeric]) {
        return [self intValue];
    }
    else {
        return 0;
    }
}
//- (NSInteger)stringLengthWithUTF8String
//{
//    NSInteger len = 0;
//    
//    const char *t = [self UTF8String];
//    if (NULL == t) 
//    {
//        return len;
//    }
//    
//    len = strlen(t);
//    return len;
//}

- (NSString *)stringByTrimming {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)urlQueryStringValueEncodeUsingUTF8Encoding {
    return [self urlQueryStringValueEncodeUsingEncoding:NSUTF8StringEncoding];
} 
- (NSString *)urlQueryStringValueEncodeUsingEncoding:(NSStringEncoding)encoding {
	NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
                                                                           (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                           CFStringConvertNSStringEncodingToEncoding(encoding)));
    return result;
}

- (NSString *)urlQueryStringValueDecodeUsingUTF8Encoding {
    return [self urlQueryStringValueDecodeUsingEncoding:NSUTF8StringEncoding];
}
- (NSString *)urlQueryStringValueDecodeUsingEncoding:(NSStringEncoding)encoding {
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                           (CFStringRef)self,
                                                                                           CFSTR(""),
                                                                                           CFStringConvertNSStringEncodingToEncoding(encoding)));
    return result;
}

- (NSString *)appendQueryStringKey:(NSString*)key andFloatValue:(CGFloat)value {
    return [self appendQueryStringKey:key andStringValue:[NSString stringWithFormat:@"%f", value]];
}

- (NSString *)appendQueryStringKey:(NSString*)key andIntValue:(NSInteger)value {
   return [self appendQueryStringKey:key andStringValue:[NSString stringWithFormat:@"%i", value]];
}

- (NSString *)appendQueryStringKey:(NSString*)key andStringValue:(NSString*)value {
    if ([self rangeOfString:@"?"].length==0) {
        return [NSString stringWithFormat:@"%@?%@=%@", [self stringByTrimming], key, [value urlQueryStringValueEncodeUsingUTF8Encoding]];
    }
    else {
        if ([self rangeOfString:@"&"].location==(self.length - 1)) {
            return [NSString stringWithFormat:@"%@%@=%@", [self stringByTrimming], key, [value urlQueryStringValueEncodeUsingUTF8Encoding]];
        }
        else {
            return [NSString stringWithFormat:@"%@&%@=%@", [self stringByTrimming], key, [value urlQueryStringValueEncodeUsingUTF8Encoding]];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)sha1Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

#pragma mark - Regex

- (BOOL)isEmail
{
    NSString *emailRegEx =  
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"  
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" 
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"  
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"  
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"  
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"  
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";  
	
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];  
    return [regExPredicate evaluateWithObject:[self lowercaseString]];  
}

- (NSString *) escapeHTML
{
	NSMutableString *s = [NSMutableString string];
	
	int start = 0;
	int len = [self length];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
				//			case '…':
				//				[s appendString:@"&hellip;"];
				//				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}


- (NSString *) unescapeHTML
{
	NSMutableString *s = [NSMutableString string];
	NSMutableString *target = [self mutableCopy];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&#39;"]) {
			[s appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&hellip;"]) {
			[s appendString:@"…"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}


- (NSString*)stringByRemovingHTML
{
	
	NSString *html = self;
    NSScanner *thescanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
	
    while ([thescanner isAtEnd] == NO) {
		[thescanner scanUpToString:@"<" intoString:NULL];
		[thescanner scanUpToString:@">" intoString:&text];
		html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@" "];
    }
	return html;
}

@end
