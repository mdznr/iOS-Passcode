//
//  MTZButton.m
//  Passcode
//
//  Created by Matt on 10/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "MTZButton.h"

@implementation MTZButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
	{
		// Some initialisation
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if ( self )
	{
		// Set up Generate Button
		[self setBackgroundImage:[UIImage imageNamed:@"buttonEnabled"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"buttonActive"] forState:UIControlStateHighlighted];
		
		[self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
		[self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		[self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
		[self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
	
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	// Drawing code.
}
*/

@end
