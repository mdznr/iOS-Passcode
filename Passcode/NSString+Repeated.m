//
//  NSString+Repeated.m
//  Passcode
//
//  Created by Matt Zanchelli on 1/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "NSString+Repeated.h"

@implementation NSString (Repeated)

+ (NSString *)stringByRepeatingCharacter:(unichar)character numberOfTimes:(NSUInteger)numberOfTimes
{
	// Create a new C string of the specified length (+1 for null terminator).
	unichar *newString = (unichar *) malloc(sizeof(unichar) * numberOfTimes+1);
	
	// Repeatedly append the character a numberOfTimes.
	NSUInteger i;
	for ( i=0 ; i<numberOfTimes; ++i ) {
		newString[i] = character;
	}
	
	// Terminate the string.
	newString[i] = '\0';
	
	// Create the NSString version.
	NSString *myNewString = [NSString stringWithCharacters:newString length:i];
	
	// The C string is no longer needed.
	free(newString);
	
	return myNewString;
}

+ (NSString *)stringByRepeatingString:(NSString *)string numberOfTimes:(NSUInteger)numberOfTimes
{
	// Create a new NSString for creating the new string.
	NSString *newString = [[NSString alloc] init];
	
	// Repeatedly append the string a numberOfTimes.
	for ( NSUInteger i=0; i<numberOfTimes; ++i ) {
		newString = [newString stringByAppendingString:[NSString stringWithFormat:@"%@", string]];
	}
	
	return newString;
}

- (NSString *)stringByInsertingString:(NSString *)string everyNumberOfCharacters:(NSUInteger)numberOfCharacters
{
	// Create a new NSString for creating the new string.
	NSString *newString = [[NSString alloc] init];
	
	// Repeatedly insert the string every numberOfCharacters.
	for ( NSUInteger i=0; i<self.length; ++i ) {
		if ( i > 0 && i % numberOfCharacters == 0 ) {
			newString = [newString stringByAppendingString:string];
		}
		newString = [newString stringByAppendingFormat:@"%c", [self characterAtIndex:i]];
	}
	
	return newString;
}

@end
