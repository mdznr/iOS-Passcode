//
//  MTZSlideToReveal.m
//  Slide to Reveal
//
//  Created by Matt on 4/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZSlideToReveal.h"

#import <QuartzCore/QuartzCore.h>

@interface MTZSlideToReveal ()

@property (strong, nonatomic) UIImageView *loupe;
@property (strong, nonatomic) UILabel *dotsLabel;
@property (strong, nonatomic) UILabel *hiddenWordLabel;
@property (nonatomic) NSUInteger numChunks;

///	Insets for the loupe relative to the field.
@property (nonatomic) UIEdgeInsets loupeBoundaryInsets;

/// Insets for the loupe graphic (shadow + border).
@property (nonatomic) UIEdgeInsets loupeContentInsets;

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
	self.loupeBoundaryInsets = UIEdgeInsetsMake(-8, 2, 2, 2);
	self.loupeContentInsets = UIEdgeInsetsMake(3, 5, 7, 5);
	
	// Background view
	UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
	backgroundView.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
	backgroundView.opaque = YES;
	backgroundView.backgroundColor = [UIColor whiteColor];
	backgroundView.layer.cornerRadius = 8;
	backgroundView.layer.masksToBounds = YES;
	backgroundView.layer.borderWidth = 0.75f;
	backgroundView.layer.borderColor = [UIColor colorWithRed:213.0f/255.0f green:217.0f/255.0f blue:223.0f/255.0f alpha:1.0f].CGColor;
	[self addSubview:backgroundView];
	
	// Dots
	_dotsLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_dotsLabel.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) {
		_dotsLabel.font = [UIFont systemFontOfSize:32.0f];
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
	_hiddenWordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_hiddenWordLabel.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) {
		_hiddenWordLabel.font = [UIFont fontWithName:@"SourceCodePro-Medium" size:24.0f];
	} else {
		_hiddenWordLabel.font = [UIFont fontWithName:@"SourceCodePro-Medium" size:42.0f];
	}
	_hiddenWordLabel.textAlignment = NSTextAlignmentCenter;
	_hiddenWordLabel.numberOfLines = 1;
	_hiddenWordLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	_hiddenWordLabel.adjustsFontSizeToFitWidth = YES;
	_hiddenWordLabel.textColor = [UIColor blackColor];
	_hiddenWordLabel.opaque = YES;
	_hiddenWordLabel.backgroundColor = [UIColor whiteColor];
	_hiddenWordLabel.alpha = 0.0f;
	[self addSubview:_hiddenWordLabel];
	
	// Loupe
	_loupe = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loupe"]];
	_loupe.hidden = YES;
	_loupe.alpha = 0.0f;
	[self addSubview:_loupe];
}

- (void)setHiddenWord:(NSString *)word
{
	_hiddenWord = word;
	
	NSUInteger chunkSize = 4;
	NSString *chunkedWord = [word stringByInsertingString:@" " everyNumberOfCharacters:chunkSize];
	_numChunks = word.length % chunkSize;
	
#warning changes frame when setting word multiple times because of changing frame while moving.
#warning Fit text size for height of view then set width dynamically. Change bounds?
	_hiddenWordLabel.text = chunkedWord;
	[_hiddenWordLabel sizeToFit];
	CGSize size = _hiddenWordLabel.frame.size;
	CGRect frame = CGRectMake(0,
							  _loupeBoundaryInsets.top,
							  size.width + 20,
							  _loupe.image.size.height - _loupeContentInsets.top - _loupeContentInsets.bottom);
	[_hiddenWordLabel setFrame:frame];
	
	// Update the number of dots.
	[_dotsLabel setText:[NSString stringByRepeatingString:@"•" numberOfTimes:word.length]];
}

- (void)didGesture:(UIGestureRecognizer *)sender
{
	switch ( sender.state ) {
		case UIGestureRecognizerStateBegan:
			[self showPopover:sender];
		case UIGestureRecognizerStateChanged:
			[self setLoupeCenter:[sender locationOfTouch:0 inView:self]];
			break;
		case UIGestureRecognizerStateEnded:
		case UITouchPhaseCancelled:
			[self hidePopover:sender];
			if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
				[self setLoupeCenter:CGPointZero];
			} else {
				[self setLoupeCenter:CGPointMake(124, 0)];
			}
			break;
		default:
			break;
	}
}

- (void)showPopover:(id)sender
{
	_loupe.hidden = NO;
	[UIView animateWithDuration:0.2f
						  delay:0.0f
						options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _loupe.alpha = 1.0f;
						 _hiddenWordLabel.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)hidePopover:(id)sender
{
	[UIView animateWithDuration:0.15f
						  delay:0.0f
						options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 _loupe.alpha = 0.0f;
						 _hiddenWordLabel.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 _loupe.hidden = YES;
					 }];
}

- (void)setLoupeCenter:(CGPoint)center
{
	CGPoint	sliderCenter = CGPointMake(self.loupe.bounds.size.width/2, self.loupe.bounds.size.height/2);
	CGFloat xMin = self.loupeBoundaryInsets.left - self.loupeContentInsets.left + sliderCenter.x;
	CGFloat xMax = self.bounds.size.width - self.loupeBoundaryInsets.right + self.loupeContentInsets.right - sliderCenter.x;
	
	CGFloat y = self.loupeBoundaryInsets.top - self.loupeContentInsets.top + sliderCenter.y;
	
	CGFloat x = BETWEEN(xMin, center.x, xMax);
	CGPoint centre = CGPointMake(x, y);
	self.loupe.center = centre;
	
	// Find the percentage of x out of the possible range of x.
	CGFloat percent = (center.x - xMin) / (xMax - xMin);
	percent = BETWEEN(0, percent, 1);
	CGFloat p = percent;
	
	// Determine position in curve function for horizontal translation (smooth "snap" to chunks).
	if ( self.hiddenWordLabel.frame.size.width > self.frame.size.width * 1.25 ) {
		NSUInteger numberOfSpaces = MAX(self.numChunks-1,1);
		CGFloat x = p + 1/(2*numberOfSpaces);
		CGFloat flx = floor(2 * numberOfSpaces * x);
		CGFloat flx1 = pow(-1.0f, flx);
		CGFloat a = (((2*numberOfSpaces*x) - (flx)) - ((flx1 + 1) / 2));
		p = (flx1 * sqrt(1 - pow(a,2)) + (flx1 - 1)/(-2) + (flx))/(2*numberOfSpaces);
		p -= (1/(2*numberOfSpaces));
	}
	
	// Translate the hidden word label horizontally.
	CGFloat shiftLeft;
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) {
		shiftLeft = p * (self.hiddenWordLabel.bounds.size.width - self.bounds.size.width);
	} else {
#warning the difference in iPhone/iPad should be handled in the insets at the top of this method.
		shiftLeft = -7 + p * (self.hiddenWordLabel.bounds.size.width - self.bounds.size.width + 14);
	}
	self.hiddenWordLabel.transform = CGAffineTransformMakeTranslation(-shiftLeft, 0);
	
	// Mask the hidden word label.
	CGRect rect = CGRectMake(shiftLeft + self.loupe.frame.origin.x + self.loupeContentInsets.left,
							 0,
							 self.loupe.frame.size.width - (self.loupeContentInsets.left + self.loupeContentInsets.right),
							 self.loupe.frame.size.height - (self.loupeContentInsets.top + self.loupeContentInsets.bottom));
	UIView *mask = [[UIView alloc] initWithFrame:rect];
	mask.layer.cornerRadius = 6;
	mask.layer.masksToBounds = YES;
	mask.backgroundColor = [UIColor blackColor];
	self.hiddenWordLabel.layer.mask = mask.layer;
}

@end
