//
//  NSString+sha256.m
//  Passcode
//
//  Created by Matt on 1/12/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "NSString+sha256.h"
#import <CommonCrypto/CommonDigest.h>

///	Digest length in bytes
#define CC_SHA256_DIGEST_LENGTH	32

@implementation NSString (sha256)

///	Create a Base64 string representation of @c NSData.
///	@param theData The data to turn into a Base64 string.
///	@return An @c NSString representing @c theData as a Base64 string.
/// @discussion Method from: http://www.cocoadev.com/index.pl?BaseSixtyFour via http://stackoverflow.com/questions/2197362/converting-nsdata-to-base64/9537527#9537527
+ (NSString *)base64StringFromData:(NSData *)theData
{
    const uint8_t *input = (const uint8_t *)[theData bytes];
    NSInteger length = [theData length];
	
	static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
	
	NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
	uint8_t *output = (uint8_t *)data.mutableBytes;
	
	for ( NSInteger i=0; i<length; i+=3 ) {
		NSInteger value = 0;
		for ( NSInteger j=i; j<(i+3); j++) {
			value <<= 8;
			if ( j < length ) {
				value |= (0xFF & input[j]);
			}
		}
		
		NSInteger theIndex = (i/3)*4;
		output[theIndex + 0] =                  table[(value >> 18) & 0x3F];
		output[theIndex + 1] =                  table[(value >> 12) & 0x3F];
		output[theIndex + 2] = (i+1) < length ? table[(value >> 6)  & 0x3F] : '=';
		output[theIndex + 3] = (i+2) < length ? table[(value >> 0)  & 0x3F] : '=';
	}
	
	return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

///	Get an @c NSData byte array directly from sha256.
///	@return An @c NSData byte array.
- (NSData *)sha256Data
{
    const char *str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG) strlen(str), result);
	return [NSData dataWithBytes:(const void *)result
						  length:sizeof(unsigned char)*CC_SHA256_DIGEST_LENGTH];
}

///	An @c NSString with hex data from sha256.
///	@return An @c NSString with hex data from sha256.
- (NSString *)sha256
{
    const char *str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG) strlen(str), result);
	
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for ( int i=0; i<CC_SHA256_DIGEST_LENGTH; i++ ) {
        [ret appendFormat:@"%02x",result[i]];
    }
	
	return ret;
}

@end
