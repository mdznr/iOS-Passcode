//
//  MTZAppearWindow.m
//  Passcode
//
//  Created by Matt on 8/31/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZAppearWindow.h"
#import "MTZAppearView.h"

#define MOTION_EFFECT_DIST 20.0f
#define APPEARANCE_DURATION 2.0f

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
	self.windowLevel = UIWindowLevelAlert;
	
	// Motion effects
	if ( NSClassFromString(@"UIInterpolatingMotionEffect") ) {
		UIInterpolatingMotionEffect *horizontal = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
		horizontal.minimumRelativeValue = @-MOTION_EFFECT_DIST;
		horizontal.maximumRelativeValue = @MOTION_EFFECT_DIST;
		UIInterpolatingMotionEffect *vertical = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
		vertical.minimumRelativeValue = @-MOTION_EFFECT_DIST;
		vertical.maximumRelativeValue = @MOTION_EFFECT_DIST;
		self.motionEffects = @[horizontal,vertical];
	}
	
	self.userInteractionEnabled = NO;
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	_mainView = [[MTZAppearView alloc] initWithFrame:self.bounds];
	_mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:_mainView];
}

- (void)setImage:(UIImage *)image
{
	_image = image;
	_mainView.image = image;
}

- (void)setText:(NSString *)text
{
	_text = text;
	_mainView.text = text;
}

- (void)setTextSize:(CGFloat)textSize
{
	_textSize = textSize;
	_mainView.textSize = textSize;
}

- (void)display
{
	[[self class] cancelPreviousPerformRequestsWithTarget:self
												 selector:@selector(hide)
												   object:nil];
	[self setHidden:NO];
	
	[_mainView display];
	
	// Hide window when done
	[self performSelector:@selector(hide) withObject:nil afterDelay:APPEARANCE_DURATION];
}

- (void)hide
{
	[self setHidden:YES];
}

@end
