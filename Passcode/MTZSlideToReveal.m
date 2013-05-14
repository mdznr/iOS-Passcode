//
//  MTZSlideToReveal.m
//  Slide to Reveal
//
//  Created by Matt on 4/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZSlideToReveal.h"
#import <QuartzCore/QuartzCore.h>

#define SQUARED(X) X*X

double squared(double x)
{
	return x*x;
}

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
	[self setOpaque:NO];
	[self setBackgroundColor:[UIColor clearColor]];
	
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		UIImage *backgroundImage = [UIImage imageNamed:@"SlideToRevealBackground"];
		backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 9, 8)];
		_background = [[UIImageView alloc] initWithImage:backgroundImage];
		
	} else {
		UIImage *backgroundImage = [UIImage imageNamed:@"iPadSlideToRevealBackground"];
		backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 9, 8)];
		_background = [[UIImageView alloc] initWithImage:backgroundImage];
	}
	[_background setFrame:self.bounds];
	[_background setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self addSubview:_background];
	
	_dotsLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.bounds.size.width,self.bounds.size.height}];
	[_dotsLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		[_dotsLabel setFont:[UIFont systemFontOfSize:30.0f]];
	} else {
		[_dotsLabel setFont:[UIFont systemFontOfSize:54.0f]];
	}
	[_dotsLabel setTextAlignment:NSTextAlignmentCenter];
	[_dotsLabel setNumberOfLines:1];
	[_dotsLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
//	[_dotsLabel setAdjustsLetterSpacingToFitWidth:YES];
	[_dotsLabel setAdjustsFontSizeToFitWidth:YES];
	[_dotsLabel setTextColor:[UIColor blackColor]];
	[_dotsLabel setOpaque:NO];
	[_dotsLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:_dotsLabel];
	
	_passwordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[_passwordLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[_passwordLabel setBounds:CGRectZero];
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		[_passwordLabel setFont:[UIFont fontWithName:@"SourceCodePro-Medium" size:24.0f]];
	} else {
		[_passwordLabel setFont:[UIFont fontWithName:@"SourceCodePro-Medium" size:42.0f]];
	}
	[_passwordLabel setTextAlignment:NSTextAlignmentCenter];
	[_passwordLabel setNumberOfLines:1];
	[_passwordLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
//	[_passwordLabel setAdjustsLetterSpacingToFitWidth:YES];
	[_passwordLabel setAdjustsFontSizeToFitWidth:YES];
	[_passwordLabel setTextColor:[UIColor blackColor]];
	[_passwordLabel setBackgroundColor:[UIColor colorWithWhite:250.0f/255.0f alpha:1.0f]];
#warning Change to gradient background?
	[_passwordLabel setAlpha:0.0f];
	[self addSubview:_passwordLabel];
	
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		_sliderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Slider"]];
	} else {
		_sliderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iPadSlider"]];
	}
	
	[_sliderView setHidden:YES];
	[_sliderView setAlpha:0.0f];
	[self addSubview:_sliderView];
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
	[self addGestureRecognizer:pan];
	
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
	[self addGestureRecognizer:longPress];
}

- (void)setWord:(NSString *)word
{
	NSString *newWord = @"";
	float numberOfChunks = 1;
	for ( NSUInteger i=0; i<word.length; ++i ) {
		if ( i>0 && i%4 == 0 ) {
			newWord = [newWord stringByAppendingString:@" "];
			numberOfChunks++;
		}
		newWord = [newWord stringByAppendingFormat:@"%c", [word characterAtIndex:i]];
	}
	_numChunks = numberOfChunks;
	_word = newWord;
	
#warning changes frame when setting word multiple times because of changing frame while moving.
#warning Fit text size for height of view then set width dynamically. Change bounds?
	[_passwordLabel setText:newWord];
	[_passwordLabel sizeToFit];
	CGSize size = _passwordLabel.frame.size;
	[_passwordLabel setFrame:CGRectMake(0, 0, size.width+20, self.bounds.size.height)];
	
	NSString *lotsOfDots = [[NSString alloc] init];
	for ( NSUInteger i=0; i<word.length; ++i ) {
		lotsOfDots = [lotsOfDots stringByAppendingString:@"•"];
	}
	[_dotsLabel setText:lotsOfDots];
}

- (void)didGesture:(id)sender
{
	if ( [sender isKindOfClass:[UIGestureRecognizer class]] ) {
//		NSLog(@"%@", sender);
		switch ( [sender state] ) {
			case UIGestureRecognizerStateBegan:
				[self showPopover:sender];
				[self setPopoverCenter:[sender locationOfTouch:0 inView:self]];
				break;
			case UIGestureRecognizerStateEnded:
				[self hidePopover:sender];
				if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
					[self setPopoverCenter:(CGPoint){0,0}];
				} else {
					[self setPopoverCenter:(CGPoint){124,0}];
				}
				break;
			case UIGestureRecognizerStateChanged:
				[self setPopoverCenter:[sender locationOfTouch:0 inView:self]];
				break;
			default:
				break;
		}
	}
}

- (void)showPopover:(id)sender
{
	[_sliderView setHidden:NO];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[_sliderView setAlpha:1.0f];
	[_passwordLabel setAlpha:1.0f];
	[UIView commitAnimations];
}

- (void)hidePopover:(id)sender
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.15f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDidStopSelector:@selector(setPopoverHidden:)];
	[_sliderView setAlpha:0.0f];
	[_passwordLabel setAlpha:0.0f];
	[UIView commitAnimations];
}

- (void)setPopoverHidden:(id)sender
{
	[_sliderView setHidden:YES];
}

- (void)setPopoverCenter:(CGPoint)center
{
	CGFloat min = _sliderView.bounds.size.width/2;
	CGFloat max = _background.bounds.size.width - _sliderView.bounds.size.width/2;
	CGFloat y = 1 + _sliderView.bounds.size.height/2;
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
	[_passwordLabel setTransform:CGAffineTransformMakeTranslation(-moveLeft, 0)];
	NSLog(@"left: %f\tframe %f", moveLeft, _passwordLabel.frame.origin.x);
	
	CGRect rect = CGRectMake(moveLeft + _sliderView.frame.origin.x + 6,
							 _sliderView.frame.origin.y + 6,
							 _sliderView.frame.size.width - 12,
							 _sliderView.frame.size.height - 34);
	UIView *mask = [[UIView alloc] initWithFrame:rect];
	[mask setBackgroundColor:[UIColor blackColor]];
	[_passwordLabel layer].mask = [mask layer];
}

@end
