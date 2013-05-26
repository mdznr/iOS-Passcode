//
//  UISegmentedControl+setItems.m
//
//  Created by Matt on 5/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "UISegmentedControl+setItems.h"

@implementation UISegmentedControl (setItems)

- (void)setItems:(NSArray *)items
{
	[self removeAllSegments];
	for ( NSUInteger i=0; i<items.count; ++i ) {
		id item = items[i];
		if ( [item isKindOfClass:[UIImage class]] ) {
			[self insertSegmentWithImage:item atIndex:i animated:NO];
		} else if ( [item isKindOfClass:[NSString class]] ) {
			[self insertSegmentWithTitle:item atIndex:i animated:NO];
		}
	}
}

@end
