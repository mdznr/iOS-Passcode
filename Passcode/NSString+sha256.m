//
//  NSString+sha256.m
//  Passcode
//
//  Created by Matt on 1/12/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "NSString+sha256.h"
#import <CommonCrypto/CommonDigest.h>

#define CC_SHA256_DIGEST_LENGTH	32	/* digest length in bytes */

@implementation NSString (sha256)

- (NSString*)sha256
{
    const char* str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
	
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
