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

@property (strong, nonatomic) UIImageView *loupe;
@property (strong, nonatomic) UILabel *dotsLabel;
@property (strong, nonatomic) UILabel *hiddenWordLabel;
@property (nonatomic) NSUInteger numChunks;

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
	self.opaque = YES;
	self.backgroundColor = [UIColor whiteColor];
	self.layer.cornerRadius = 8;
	self.layer.masksToBounds = YES;
	self.layer.borderWidth = 0.75f;
	self.layer.borderColor = [UIColor colorWithRed:213.0f/255.0f green:217.0f/255.0f blue:223.0f/255.0f alpha:1.0f].CGColor;
	
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
	_hiddenWordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_hiddenWordLabel.autoresizingMask = UIViewAutoresizingFlexibleSize;
	_hiddenWordLabel.bounds = CGRectZero;
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
	
#warning are these gestures still used?
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
	[self addGestureRecognizer:pan];
	
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didGesture:)];
	[self addGestureRecognizer:longPress];
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
	[_hiddenWordLabel setFrame:CGRectMake(0, -9, size.width + 20, self.bounds.size.height)];
	
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
	// Insets for the loupe relative to the field.
	UIEdgeInsets loupeBoundaryInsets = UIEdgeInsetsMake(0, 0, -12, 0);
	
	// Insets for the loupe graphic (shadow + border).
	UIEdgeInsets loupeContentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
#warning should just use loupe mask image? instead of getting border radius and use at the bottom
	
	CGPoint	sliderCenter = (CGPoint) {_loupe.bounds.size.width/2, _loupe.bounds.size.height/2};
	CGFloat xMin = loupeBoundaryInsets.left + sliderCenter.x;
	CGFloat xMax = self.bounds.size.width - loupeBoundaryInsets.right - sliderCenter.x;
	
	CGFloat y = loupeBoundaryInsets.top + sliderCenter.y;
	
	CGFloat x = BETWEEN(xMin, center.x, xMax);
	CGPoint centre = (CGPoint){x, y};
	_loupe.center = centre;
	
	// Find the percentage of x out of the possible range of x.
	CGFloat percent = (center.x - xMin) / (xMax - xMin);
	percent = BETWEEN(0, percent, 1);
	CGFloat p = percent;
	
	// Determine position in curve function for horizontal translation (smooth "snap" to chunks).
	if ( _hiddenWordLabel.frame.size.width > self.frame.size.width * 1.25 ) {
		NSUInteger numberOfSpaces = MAX(_numChunks-1,1);
		CGFloat x = p + 1/(2*numberOfSpaces);
		CGFloat flx = floor(2 * numberOfSpaces * x);
		CGFloat flx1 = pow(-1.0f, flx);
		CGFloat a = (((2*numberOfSpaces*x) - (flx)) - ((flx1 + 1) / 2));
		p = (flx1 * sqrt(1 - pow(a,2)) + (flx1 - 1)/(-2) + (flx))/(2*numberOfSpaces);
		p -= (1/(2*numberOfSpaces));
	}
	
	// Translate the hidden word label horizontally.
	CGFloat shiftLeft;
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		shiftLeft = p * (_hiddenWordLabel.bounds.size.width - self.bounds.size.width);
	} else {
#warning the difference in iPhone/iPad should be handled in the insets at the top of this method.
		shiftLeft = -7 + p * (_hiddenWordLabel.bounds.size.width - self.bounds.size.width + 14);
	}
	_hiddenWordLabel.transform = CGAffineTransformMakeTranslation(-shiftLeft, 0);
	
	// Mask the hidden word label
	CGRect rect = CGRectMake(shiftLeft + _loupe.frame.origin.x + loupeContentInsets.left,
							 _loupe.frame.origin.y + loupeContentInsets.top,
							 _loupe.frame.size.width - (loupeContentInsets.left + loupeContentInsets.right),
							 _loupe.frame.size.height - (loupeContentInsets.top + loupeContentInsets.bottom));
	UIView *mask = [[UIView alloc] initWithFrame:rect];
	mask.backgroundColor = [UIColor blackColor];
	_hiddenWordLabel.layer.mask = mask.layer;
}

@end
