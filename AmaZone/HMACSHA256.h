//
//  HMACSHA256.h
//  AmaZone
//
//  Created by Marc Mauger on 11/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

// http://forums.macrumors.com/archive/index.php/t-776833.html


@interface HMACSHA256 : NSObject
{
	
}

#pragma mark Public Interface
+ (NSString *)getSignedRequest:(NSString *)undatedUnsortedUnsignedUrlString
					withSecret:(NSString *)secretKey;

#pragma mark Helpers for Creation of Signed Amazon.com AWS REST Request
+ (NSString *)appendTimestamp:(NSString *)undatedUrlString;
+ (NSString *)sortUrlString:(NSString *)unsortedUrlString;
+ (NSString *)signUrlString:(NSString *)unsignedUrlString
				 withSecret:(NSString *)secretKey;

#pragma mark HMAC SHA256 signing, Base64 encoding, and Canonical Transformation
+ (NSData *)HMACforString:(NSString *)string
			   withSecret:(NSString *)secretKey;
+ (NSString *)base64forData:(NSData *)data;
+ (NSString *)transformServiceAddress:(NSString *)serviceAddress;

@end
