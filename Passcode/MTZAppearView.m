//
//  MTZAppearView.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "MTZAppearView.h"

#define DEFAULT_FRAME CGRectMake(0, 0, 128, 128)
#define DEFAULT_CORNER_RADIUS 10
#define DEFAULT_TEXT_SIZE 16

#define DISPLAY_DURATION 1.0f
#define FADE_OUT_DURATION 0.75f

@interface MTZAppearView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *label;

@end

@implementation MTZAppearView


#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( self ) {
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
		[self setup];
    }
    return self;
}

- (id)init
{
	return [self initWithFrame:DEFAULT_FRAME];
}

- (void)setup
{
	self.opaque = NO;
	
	// Image.
	self.imageView = [[UIImageView alloc] initWithFrame:
				  CGRectMake(floorf((self.frame.size.width  - self.image.size.width )/2),
							 floorf((self.frame.size.height - self.image.size.height)/2) - 14,
							 self.image.size.width,
							 self.image.size.height)];
	self.imageView.autoresizingMask = UIViewAutoresizingFlexibleMargins;
	self.imageView.image = _image;
	[self addSubview:self.imageView];
	
	// Default text size.
	_textSize = DEFAULT_TEXT_SIZE;
	
	// The text label.
	self.label = [[UILabel alloc] init];
	self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	self.label.text = self.text;
	self.label.backgroundColor = [UIColor clearColor];
	self.label.textColor = [UIColor whiteColor];
	self.label.numberOfLines = 1;
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.shadowColor = [UIColor clearColor];
	self.label.font = [UIFont boldSystemFontOfSize:self.textSize];
	[self addSubview:self.label];
}


#pragma mark - Properties

- (void)setImage:(UIImage *)image
{
	_image = image;
	_imageView.image = _image;
	
	// Update the position of the image view.
	_imageView.frame = CGRectMake(floorf((self.frame.size.width  - _image.size.width )/2),
								  floorf((self.frame.size.height - _image.size.height)/2) - 14,
								  _image.size.width,
								  _image.size.height);
}

- (void)setText:(NSString *)text
{
	_text = text;
	self.label.text = text;
	
	// Update the position of the text label.
	self.label.frame = CGRectMake(0, self.frame.size.height - 42, self.frame.size.width, 32);
}

- (void)setTextSize:(CGFloat)textSize
{
	_textSize = textSize;
	self.label.font = [UIFont boldSystemFontOfSize:textSize];
}


#pragma mark - Drawing and Displaying

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:self.bounds
												  cornerRadius:DEFAULT_CORNER_RADIUS];
	[[UIColor colorWithWhite:0.0f alpha:0.77f] setFill];
	[bp fill];
}

- (void)display
{
	// Cancel any prevoius requests to fade out.
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOut) object:nil];
	
	// Set the alpha to 100%.
	self.alpha = 1.0f;
	
	// Request a fade out (after a duration).
	[self performSelector:@selector(fadeOut) withObject:nil afterDelay:DISPLAY_DURATION];
}

- (void)fadeOut
{
	[UIView animateWithDuration:FADE_OUT_DURATION
						  delay:0.0f
						options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.alpha = 0.0f;
					 }
					 completion:nil];
}

@end
