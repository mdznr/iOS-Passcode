//
//  MTZSlideToReveal.m
//  Slide to Reveal
//
//  Created by Matt on 4/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZSlideToReveal.h"

#import <QuartzCore/QuartzCore.h>

#import "MTZMacros.h"
#import "NSString+Repeated.h"

@interface MTZSlideToReveal ()

@property (strong, nonatomic) UIImageView *background;
@property (strong, nonatomic) UIImageView *sliderView;
@property (strong, nonatomic) UILabel *dotsLabel;
@property (strong, nonatomic) UILabel *passwordLabel;
@property (nonatomic) float numChunks;

@end

@implementation MTZSlideToReveal

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		// Initalization code
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
		// Initalization code
		[self setup];
	}
	return self;
}

- (void)setup
{
	self.opaque = NO;
	self.backgroundColor = [UIColor clearColor];
	
	// Background
	UIImage *backgroundImage = [UIImage imageNamed:@"RevealBackground"];
	backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
	_background = [[UIImageView alloc] initWithImage:backgroundImage];
	_background.frame = self.bounds;
	_background.autoresizingMask = UIViewAutoresizingFlexibleSize;
	[self addSubview:_background];
	
	// Dots
	_dotsLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_dotsLabel.autoresizingMask = UIViewAutoresizingFlexibleSize;
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		_dotsLabel.font = [UIFont systemFontOfSize:30.0f];
	} else {
		_dotsLabel.font = [UIFont systemFontOfSize:54.0f];
	}
	_dotsLabel.textAlignment = NSTextAlignmentCenter;
	_dotsLabel.numberOfLines = 1;
	_dotsLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	_dotsLabel.adjustsFontSizeToFitWidth = YES;
	_dotsLabel.textColor = [UIColor blackColor];
	_dotsLabel.opaque = NO;
	_dotsLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:_dotsLabel];
	
	// Hidden Word
	_passwordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_passwordLabel.autoresizingMask = UIViewAutoresizingFlexibleSize;
	_passwordLabel.bounds = CGRectZero;
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) {
		_passwordLabel.font = [UIFont fontWithName:@"SourceCodePro-Medium" size:24.0f];
	} else {
		_passwordLabel.font = [UIFont fontWithName:@"SourceCodePro-Medium" size:42.0f];
	}
	_passwordLabel.textAlignment = NSTextAlignmentCenter;
	_passwordLabel.numberOfLines = 1;
	_passwordLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	_passwordLabel.adjustsFontSizeToFitWidth = YES;
	_passwordLabel.textColor = [UIColor blackColor];
	
//	_passwordLabel.opaque = NO;
//	_passwordLabel.backgroundColor = [UIColor clearColor];
#warning passwordLabel background color?
	_passwordLabel.backgroundColor = [UIColor whiteColor];
	
	_passwordLabel.alpha = 0.0f;
	[self addSubview:_passwordLabel];
	
	// Loupe
	_sliderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loupe"]];
	_sliderView.hidden = YES;
	_sliderView.alpha = 0.0f;
	[self addSubview:_sliderView];
	
#warning are these gestures still used?
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
	[self addGestureRecognizer:pan];
	
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
	[self addGestureRecognizer:longPress];
}

- (void)setWord:(NSString *)word
{
	if ( [_word isEqualToString:word] ) return;
	
	_word = word;
	
	NSUInteger chunkSize = 4;
	NSString *chunkedWord = [word stringByInsertingString:@" " everyNumberOfCharacters:chunkSize];
	_numChunks = word.length % chunkSize;
	
#warning changes frame when setting word multiple times because of changing frame while moving.
#warning Fit text size for height of view then set width dynamically. Change bounds?
	_passwordLabel.text = chunkedWord;
	[_passwordLabel sizeToFit];
	CGSize size = _passwordLabel.frame.size;
	[_passwordLabel setFrame:CGRectMake(0, -9, size.width + 20, self.bounds.size.height)];
	
	// Update dots
	NSString *dots = [NSString stringByRepeatingString:@"•" numberOfTimes:word.length];
	[_dotsLabel setText:dots];
}

- (void)didGesture:(id)sender
{
	if ( [sender isKindOfClass:[UIGestureRecognizer class]] ) {
		switch ( ((UIGestureRecognizer *) sender).state ) {
			case UIGestureRecognizerStateBegan:
				[self showPopover:sender];
			case UIGestureRecognizerStateChanged:
				[self setPopoverCenter:[sender locationOfTouch:0 inView:self]];
				break;
			case UIGestureRecognizerStateEnded:
			case UITouchPhaseCancelled:
				[self hidePopover:sender];
				if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
					[self setPopoverCenter:(CGPoint){0,0}];
				} else {
					[self setPopoverCenter:(CGPoint){124,0}];
				}
				break;
			default:
				break;
		}
	}
}

- (void)showPopover:(id)sender
{
	_sliderView.hidden = NO;
	[UIView animateWithDuration:0.2f
						  delay:0.0f
						options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _sliderView.alpha = 1.0f;
						 _passwordLabel.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)hidePopover:(id)sender
{
	[UIView animateWithDuration:0.15f
						  delay:0.0f
						options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _sliderView.alpha = 0.0f;
						 _passwordLabel.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _sliderView.hidden = YES;
					 }];
}

- (void)setPopoverCenter:(CGPoint)center
{
	CGFloat min = _sliderView.bounds.size.width/2;
	CGFloat max = _background.bounds.size.width - _sliderView.bounds.size.width/2;
	CGFloat y = -12 + _sliderView.bounds.size.height/2;
	CGPoint centre = CGPointMake(MAX(MIN(center.x, max), min), y);
	[_sliderView setCenter:centre];
	
	CGFloat percent = MIN(MAX(((center.x - min) / (max - min)), 0), 1);
//	NSLog(@"PERCENT: %f", percent);
	float p = percent;
	
//	NSLog(@"%f", _passwordLabel.frame.size.width);
//	NSLog(@"%f", self.frame.size.width);
	if ( _passwordLabel.frame.size.width > self.frame.size.width * 1.25 ) {
		double numberOfSpaces = MAX(_numChunks-1,1);
		double x = p + 1/(2*numberOfSpaces);
		double flx = floor(2 * numberOfSpaces * x);
		double flx1 = pow((double)-1, flx);
		double a = (((2*numberOfSpaces*x) - (flx)) - ((flx1 + 1) / 2));
		p = (flx1 * sqrt(1 - pow(a,2)) + (flx1 - 1)/(-2) + (flx))/(2*numberOfSpaces);
		p -= (1/(2*numberOfSpaces));
	}
//	NSLog(@"Percent: %f", p);
	
	CGFloat moveLeft;
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		moveLeft = p * (_passwordLabel.bounds.size.width - self.bounds.size.width);
	} else {
		moveLeft = -7 + p * (_passwordLabel.bounds.size.width - self.bounds.size.width + 14);
	}
	_passwordLabel.transform = CGAffineTransformMakeTranslation(-moveLeft, 0);
//	NSLog(@"left: %f\tframe %f", moveLeft, _passwordLabel.frame.origin.x);
	
	CGFloat padding = 5;
	CGRect rect = CGRectMake(moveLeft + _sliderView.frame.origin.x + padding,
							 _sliderView.frame.origin.y + padding,
							 _sliderView.frame.size.width - (2*padding),
							 _sliderView.frame.size.height - (2*padding));
	UIView *mask = [[UIView alloc] initWithFrame:rect];
	mask.backgroundColor = [UIColor blackColor];
	_passwordLabel.layer.mask = mask.layer;
}

@end
