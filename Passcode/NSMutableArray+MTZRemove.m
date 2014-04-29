//
//  NSMutableArray+MTZRemove.m
//  Passcode
//
//  Created by Matt on 5/13/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "NSMutableArray+MTZRemove.h"

@implementation NSMutableArray (MTZRemove)

- (void)removeFirstOfEachObjectInArray:(NSArray *)array
{
	for ( id x in array ) {
		NSUInteger i = [self indexOfObject:x];
		if ( i != NSNotFound ) {
			[self removeObjectAtIndex:i];
		}
	}
}

@end
