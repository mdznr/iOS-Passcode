//
//  NSURL+DomainName.m
//  Passcode
//
//  Created by Matt Zanchelli on 4/22/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "NSURL+DomainName.h"

@implementation NSURL (DomainName)

- (NSString *)domainName
{
	// The components of the host. (Ex: @[@"www", @"apple", @"com"])
	NSArray *components = [self.host componentsSeparatedByString:@"."];
	
	// Make sure there are enough components.
	if ( [components count] < 2 ) {
		return nil;
	}
	
	// Get the component immediately before the TLD.
	NSString *component = components[[components count]-2];
	
	// But not if it's a standard TLD prefix (as in ".co.uk" or ".org.uk")
	if ( [component isEqualToString:@"co"] || [component isEqualToString:@"org"] ) {
		if ( [components count] < 3 ) {
			return nil;
		}
		
		// Get the third to last component.
		component = components[[components count]-3];
	}
	
	return component;
}

@end
