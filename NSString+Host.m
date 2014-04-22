//
//  NSString+Host.m
//  Passcode
//
//  Created by Matt Zanchelli on 4/21/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "NSString+Host.h"

@implementation NSString (Host)

#warning rename host to something else.
- (NSString *)hostString
{
	// Use NSURLComponents, if possible. (iOS 7+)
	if ( NSStringFromClass([NSURLComponents class]) ) {
		NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithString:self];
		NSArray *components = [URLComponents.host componentsSeparatedByString:@"."];
		
		// Return the component right before the TLD.
		if ( [components count] < 2 ) {
			return nil;
		}
		
		NSString *host = components[[components count]-2];
		if ( [host isEqualToString:@"co"] ) {
			if ( [components count] < 3 ) {
				return nil;
			} else {
				host = components[[components count]-3];
			}
		}
		return host;
	}
	
	// Must start with http:// or https://
	if ( [self hasPrefix:@"http://"] || [self hasPrefix:@"https://"] ) {
		NSURL *url = [[NSURL alloc] initWithString:self];
		NSArray *components = [[url host] componentsSeparatedByString:@"."];
		return components[[components count]-2];
	}
	
	return nil;
}

@end
