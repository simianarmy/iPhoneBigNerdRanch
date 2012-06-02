#import "HMACSHA256.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation HMACSHA256


#pragma mark Public Interface

+ (NSString *)getSignedRequest:(NSString *)undatedUnsortedUnsignedUrlString
					withSecret:(NSString *)secretKey
{
	// Append "&Timestamp=XXXX" field.
	NSString *datedUnsortedUnsignedUrlString	= [HMACSHA256 appendTimestamp:undatedUnsortedUnsignedUrlString];
	
	// Sort and % escape the request fields.
	NSString *datedSortedUnsignedUrlString		= [HMACSHA256 sortUrlString:datedUnsortedUnsignedUrlString];
	
	// Calc and append the "&Signature=XXXX" field to the rest of the request.
	NSString *datedSortedSignedUrlString		= [HMACSHA256 signUrlString:datedSortedUnsignedUrlString withSecret:secretKey];
	
	return datedSortedSignedUrlString;
}


#pragma mark Helpers for Creation of Signed Amazon.com AWS REST Request

+ (NSString *)appendTimestamp:(NSString *)undatedUrlString
{
	// Adds a timestamp (now) to the AWS REST request in GMT.
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	NSString *date = [dateFormatter stringFromDate:[NSDate date]];
	NSString *datedUrlString = [undatedUrlString stringByAppendingFormat:@"&Timestamp=%@",date];
	
	[dateFormatter release];
	dateFormatter = nil;
	
	return datedUrlString;
}

+ (NSString *)sortUrlString:(NSString *)unsortedUrlString
{
	// Sorts request fields by "binary value" (not alphabetically).
	
	// Splitting the service address (e.g. "http://ecs.amazonaws.com/onca/xml?") from REST request.
	NSArray	 *unsortedUrlStringArrayWithHTTPAddress = [unsortedUrlString componentsSeparatedByString:@"?"];
	NSString *serviceAddress						= [NSString stringWithFormat:@"%@", [unsortedUrlStringArrayWithHTTPAddress objectAtIndex:0]];
	
	// Capturing 2nd half of the REST request.  This is what we will sort.
	NSString *unsortedUrlStringWithoutHTTPAddress	= [NSString stringWithFormat:@"%@", [unsortedUrlStringArrayWithHTTPAddress objectAtIndex:1]];
	
	// % escape the 2nd half of the REST request string.
	NSString *escapedUnsortedUrlString = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)unsortedUrlStringWithoutHTTPAddress,
																							 NULL, (CFStringRef)@"!*'();:@+$,/?%#[]",
																							 kCFStringEncodingUTF8);
	[escapedUnsortedUrlString autorelease];
	
	// Split 2nd half of REST request by "&".
	NSArray *arrayUrlString = [escapedUnsortedUrlString componentsSeparatedByString:@"&"];
	
	// ...then perform a "byte sort" (insensitive to case).
	arrayUrlString = [arrayUrlString sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	// Join all items.
	int i, itemCount = [arrayUrlString count];
	
	NSString *enumString;
	NSString *appendStringArray;
	
	// Find and place the AWSAccessKeyId=XXXX field first.
	for (enumString in arrayUrlString) {
		if ([enumString rangeOfString:@"AWSAccessKeyId="].location != NSNotFound) {
			appendStringArray = [NSString stringWithFormat:@"%@", enumString];
		}
	}
	
	// Append the other fields to the first field without inserting "AWSAccessKeyId=" a second time.
	for (i = 0; i < itemCount;i++) {
		if([[arrayUrlString objectAtIndex:i] rangeOfString:@"AWSAccessKeyId="].location == NSNotFound) {
			appendStringArray = [appendStringArray stringByAppendingFormat:@"&%@", [arrayUrlString objectAtIndex:i]];
		}
	}
	
	// Join the |serviceAddress| string to the request.
	appendStringArray = [NSString stringWithFormat:@"%@?%@", serviceAddress, appendStringArray];
	
	return appendStringArray;
}

+ (NSString *)signUrlString:(NSString *)unsignedUrlString
				 withSecret:(NSString *)secretKey
{
	// Splitting the service address (e.g. "http://ecs.amazonaws.com/onca/xml?") from REST request.
	NSArray  *splitRequest				= [unsignedUrlString componentsSeparatedByString:@"?"];
	NSString *serviceAddress			= [NSString stringWithFormat:@"%@", [splitRequest objectAtIndex:0]];
	
	// Capturing 2nd half of the REST request.  This is what we will sign. 
	NSString *canonicalRequestForm		= [NSString stringWithFormat:@"%@", [splitRequest objectAtIndex:1]];
	
	// Getting the canonical form of the service address.
	NSString *sACanonicalForm			= [HMACSHA256 transformServiceAddress:serviceAddress];
	NSString *fullCanonicalFormRequest	= [NSString stringWithFormat:@"%@%@", sACanonicalForm, canonicalRequestForm];
	
	// Calculating the signature from the canonical request and % escaping it.
	NSString *signatureUncoded			= [HMACSHA256 base64forData:[HMACSHA256 HMACforString:fullCanonicalFormRequest withSecret:secretKey]];
	NSString *signature					= (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) signatureUncoded,
																							  NULL, (CFStringRef) @"+/=",
																							  kCFStringEncodingUTF8);
	[signature autorelease];
	
	// Rejoining service address string, canonical request string, and the signature field.
	NSString *signedUrlString			= [NSString stringWithFormat:@"%@?%@&Signature=%@", serviceAddress, canonicalRequestForm, signature];
	
	return signedUrlString;
}


#pragma mark HMAC SHA256 signing, Base64 encoding, and Canonical Transformation

+ (NSData *)HMACforString:(NSString *)string
			   withSecret:(NSString *)secretKey
{
	// Returns an NSData created by signing a string w/SHA256 using secretKey.
	
	NSData *clearTextData = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSData *secretKeyData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
	
	uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
	
	// CommonCrypto Functions
	CCHmacContext hmacContext;
	CCHmacInit(&hmacContext, kCCHmacAlgSHA256, secretKeyData.bytes, secretKeyData.length);
	CCHmacUpdate(&hmacContext, clearTextData.bytes, clearTextData.length);
	CCHmacFinal(&hmacContext, digest);
	
	NSData *result = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
	
	return result;
}

+ (NSString *)base64forData:(NSData *)data
{
	// Encodes given data into a MIME Base64 string.
	
	static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	
	if ([data length] == 0)
		return @"";
	
	char *characters = malloc((([data length] + 2) / 3) * 4);
	if (characters == NULL)
		return nil;
	NSUInteger length = 0;
	
	NSUInteger i = 0;
	while (i < [data length])
	{
		char buffer[3] = {0,0,0};
		short bufferLength = 0;
		while (bufferLength < 3 && i < [data length])
			buffer[bufferLength++] = ((char *)[data bytes])[i++];
		
		// Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
		characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
		characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
		if (bufferLength > 1)
			characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
		else characters[length++] = '=';
		if (bufferLength > 2)
			characters[length++] = encodingTable[buffer[2] & 0x3F];
		else characters[length++] = '='; 
	}
	
	NSString *encodedString = [[[NSString alloc] initWithBytesNoCopy:characters
															  length:length
															encoding:NSASCIIStringEncoding
														freeWhenDone:YES] autorelease];
	
	return encodedString;
}

+ (NSString *)transformServiceAddress:(NSString *)serviceAddress
{
	// Transform the serviceAddress string to fit for the signature calculation.
	
	NSString *tSA = [serviceAddress stringByReplacingOccurrencesOfString:@"http://" withString:@"GET\n"];
	tSA = [tSA stringByReplacingOccurrencesOfString:@"/onca/xml" withString:@"\n/onca/xml\n"];
	return tSA;
}


@end
