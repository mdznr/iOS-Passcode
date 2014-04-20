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

///	The main view for the content.
@property (strong, nonatomic) MTZAppearView *mainView;

@end

@implementation MTZAppearWindow


#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		// Initialization code
		[self setup];
	}
	return self;
}

- (id)init
{
	self = [super init];
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
	
	// Add main view for content.
	_mainView = [[MTZAppearView alloc] initWithFrame:self.bounds];
	_mainView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:_mainView];
}


#pragma mark - Properties

- (void)setImage:(UIImage *)image
{
	_mainView.image = image;
}

- (UIImage *)image
{
	return _mainView.image;
}

- (void)setText:(NSString *)text
{
	_mainView.text = text;
}

- (NSString *)text
{
	return _mainView.text;
}

- (void)setTextSize:(CGFloat)textSize
{
	_mainView.textSize = textSize;
}

- (CGFloat)textSize
{
	return _mainView.textSize;
}


#pragma mark - Methods

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
