//
//  PCDPasscodeGenerator.m
//  Passcode
//
//  Created by Matt on 5/27/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDPasscodeGenerator.h"
#import "NSString+characterSwaps.h"
#import "NSString+sha256.h"

@implementation PCDPasscodeGenerator

static PCDPasscodeGenerator *sharedSingleton;

+ (void)initialize
{
    static BOOL initialized = NO;
    if( !initialized ) {
        initialized = YES;
        sharedSingleton = [[PCDPasscodeGenerator alloc] init];
    }
}

+ (id)sharedInstance
{
	return sharedSingleton;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setupDefaults];
	}
	return self;
}

- (void)setupDefaults
{
	_length = 16;
}

- (NSString *)passcodeForDomain:(NSString *)domain andMasterPassword:(NSString *)masterPassword
{
	// Create the hash
	NSString *concatination = [[domain lowercaseString] stringByAppendingString:masterPassword];
	NSData *passwordData = [concatination sha256Data];
	NSString *password = [NSString base64StringFromData:passwordData];
	
	// Now replace + and / with ! and # to improve password compatibility
	password = [password stringByReplacingOccurrencesOfCharacter:'+' withCharacter:'!'];
	password = [password stringByReplacingOccurrencesOfCharacter:'/' withCharacter:'#'];
	
	password = [password substringToIndex:_length];
	
	return password;
}

@end
