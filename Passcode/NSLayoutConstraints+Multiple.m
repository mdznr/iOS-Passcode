//
//  NSLayoutConstraints+Multiple.m
//  Passcode
//
//  Created by Matt Zanchelli on 7/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "NSLayoutConstraints+Multiple.h"

@implementation NSLayoutConstraint (Multiple)

+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
	NSMutableArray *constraints = [NSMutableArray array];
	for (NSString *format in formats) {
		[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views]];
	}
	return constraints;
}

@end
