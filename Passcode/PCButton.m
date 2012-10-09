//
//  PCButton.m
//  Passcode
//
//  Created by Matt on 10/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCButton.h"

@implementation PCButton

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
		// If running iOS 6.0 or higher, use smooth button resources, else glossy.
		BOOL smooth = NO;
		NSString *reqSysVer = @"6.0";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([ currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending ) smooth = YES;
		 
		// Set up Generate Button
		
		if ( smooth )	// iOS 6: smooth assets
		{
			[self setBackgroundImage:[UIImage imageNamed:@"whiteButton"] forState:UIControlStateNormal];
			[self setBackgroundImage:[UIImage imageNamed:@"whiteButtonActive"] forState:UIControlStateHighlighted];
		}
		else	// Less than iOS 6: glossy assets
		{
			[self setBackgroundImage:[UIImage imageNamed:@"whiteButtonGlossy"] forState:UIControlStateNormal];
			[self setBackgroundImage:[UIImage imageNamed:@"whiteButtonGlossyActive"] forState:UIControlStateHighlighted];
		}
		
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
