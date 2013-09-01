//
//  MTZAppearWindow.m
//  Passcode
//
//  Created by Matt on 8/31/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZAppearWindow.h"
#import "MTZAppearView.h"

@interface MTZAppearWindow ()

@property (strong, nonatomic) MTZAppearView *mainView;

@end

@implementation MTZAppearWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (void)setup
{
	self.userInteractionEnabled = NO;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	_mainView = [[MTZAppearView alloc] initWithFrame:self.bounds];
	_mainView.imageName = @"copied";
	_mainView.text = @"Copied";
	_mainView.textSize = 16;
	[self addSubview:_mainView];
}

- (void)display
{
	[self setHidden:NO];
	
	[_mainView display];
	
	// Hide window when done
	[self performSelector:@selector(hide) withObject:nil afterDelay:1.75f];
}

- (void)hide
{
	[self setHidden:YES];
}

@end
