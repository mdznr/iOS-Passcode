//
//  MTZTextField.m
//  Passcode
//
//  Created by Matt Zanchelli on 12/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZTextField.h"

@implementation MTZTextField

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( !self ) { return self; }
	
	[self _setUpMTZTextField];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( !self ) { return self; }
	
	[self _setUpMTZTextField];
	return self;
}

- (id)init
{
	self = [super init];
	if ( !self ) { return self; }
	
	[self _setUpMTZTextField];
	return self;
}

- (void)_setUpMTZTextField
{
	_contentInset = UIEdgeInsetsZero;
}

/*
- (CGRect)rectForBounds:(CGRect)bounds
{
	return CGRectMake(bounds.origin.x + _contentInset.left,
					  bounds.origin.y + _contentInset.top,
					  bounds.size.width - _contentInset.left - _contentInset.right,
					  bounds.size.height - _contentInset.top - _contentInset.bottom);
}

// Placeholder text position
- (CGRect)textRectForBounds:(CGRect)bounds
{
	return [self rectForBounds:bounds];
}

// Text position
- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return [self rectForBounds:bounds];
}
 */

// Only show certain actions in text selection
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
	if ( (action == @selector(cut:)) ||
		 (action == @selector(copy:)) ||
		 (action == @selector(select:)) ||
         (action == @selector(selectAll:)) ||
		 (action == @selector(paste:)) ||
		 (action == @selector(delete:)))
	{
        return [super canPerformAction:action withSender:sender];
	}
	
    return NO;
}

@end
