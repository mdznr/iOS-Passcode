//
//  NSString+Repeated.m
//  Passcode
//
//  Created by Matt Zanchelli on 1/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "NSString+Repeated.h"

@implementation NSString (Repeated)

#warning There has to be more efficient ways to do this
#warning Is it worth it to do it in C?
#warning Can this be done better with NSString (without C)?

+ (NSString *)stringByRepeatingString:(NSString *)string numberOfTimes:(NSUInteger)numberOfTimes
{
	NSString *ret = @"";
	for ( NSUInteger i=0; i<numberOfTimes; ++i ) {
		ret = [ret stringByAppendingString:[NSString stringWithFormat:@"%@", string]];
	}
	return ret;
}

- (NSString *)stringByInsertingString:(NSString *)string everyNumberOfCharacters:(NSUInteger)numberOfCharacters
{
	NSString *newString = @"";
#warning How OK is it to use CGFloat for non-graphics things?
	CGFloat numberOfChunks = 1;
	for ( NSUInteger i=0; i<self.length; ++i ) {
		if ( i>0 && i%4 == 0 ) {
			newString = [newString stringByAppendingString:string];
			numberOfChunks++;
		}
		newString = [newString stringByAppendingFormat:@"%c", [self characterAtIndex:i]];
	}
	return newString;
}

@end
