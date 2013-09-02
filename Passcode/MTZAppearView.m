//
//  MTZAppearView.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "MTZAppearView.h"

#define DEFAULT_CORNER_RADIUS 8

@interface MTZAppearView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textView;

@end

@implementation MTZAppearView

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
	CGRect frame = CGRectMake(0, 0, 128, 128);
	self = [self initWithFrame:frame];
	return self;
}

- (void)setup
{
	self.opaque = NO;
	
	// Image
	UIImage *image = [UIImage imageNamed:_imageName];
	_imageView = [[UIImageView alloc] initWithFrame:
				  CGRectMake(floorf((self.frame.size.width  - image.size.width )/2),
							 floorf((self.frame.size.height - image.size.height)/2) - 14,
							 image.size.width,
							 image.size.height)];
	_imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
								| UIViewAutoresizingFlexibleBottomMargin
								| UIViewAutoresizingFlexibleLeftMargin
								| UIViewAutoresizingFlexibleRightMargin;
	_imageView.image = image;
	[self addSubview:_imageView];
	
	// Text
	_textView = [[UILabel alloc] init];
	_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_textView.text = _text;
	_textView.backgroundColor = [UIColor clearColor];
	_textView.textColor = [UIColor whiteColor];
	_textView.numberOfLines = 1;
	_textView.textAlignment = NSTextAlignmentCenter;
	_textView.shadowColor = [UIColor blackColor];
	_textView.shadowOffset = CGSizeMake(0, 1);
	_textView.font = [UIFont boldSystemFontOfSize:_textSize];
	[self addSubview:_textView];
}

- (void)setImageName:(NSString *)imageName
{
	_imageName = imageName;
	UIImage *image = [UIImage imageNamed:imageName];
	_imageView.image = image;
	_imageView.frame = CGRectMake(floorf((self.frame.size.width  - image.size.width )/2),
								  floorf((self.frame.size.height - image.size.height)/2) + 14,
								  image.size.width,
								  image.size.height);
}

- (void)setText:(NSString *)text
{
	_text = text;
	_textView.text = text;
	_textView.frame = CGRectMake(0, 86, self.frame.size.width, 32);
}

- (void)setTextSize:(CGFloat)textSize
{
	_textSize = textSize;
	_textView.font = [UIFont boldSystemFontOfSize:textSize];
}

- (void)drawRect:(CGRect)rect
{
	UIBezierPath *bp = [UIBezierPath bezierPathWithRoundedRect:self.bounds
												  cornerRadius:DEFAULT_CORNER_RADIUS];
	[[UIColor colorWithWhite:0.0f alpha:0.7f] setFill];
	[bp fill];
}

- (void)display
{
	[[self layer] removeAllAnimations];
	[[self class] cancelPreviousPerformRequestsWithTarget:self];
	[self setAlpha:1.0f];
	[self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.0f];
}

- (void)fadeOut
{
	CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[fadeOut setFromValue:@1.0f];
	[fadeOut setToValue:@0.0f];
	[fadeOut setDuration:0.75f];
	[[self layer] addAnimation:fadeOut forKey:@"alpha"];
	[self setAlpha:0.0f];
}

@end
