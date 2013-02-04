//
//  NSString+characterSwaps.m
//  test
//
//  Created by Matt on 2/3/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "NSString+characterSwaps.h"

@implementation NSString (characterSwaps)

- (NSString *)stringByReplacingOccurrencesOfCharacter:(const unichar)fromCharacter
										withCharacter:(const unichar)toCharacter
{
	NSString *fromString = [NSString stringWithCharacters:&fromCharacter length:1];
	NSString *toString = [NSString stringWithCharacters:&toCharacter length:1];
	return [self stringByReplacingOccurrencesOfString:fromString withString:toString];
}

@end
