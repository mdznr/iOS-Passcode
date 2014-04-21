//
//  MTZAppearView.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "MTZAppearView.h"

#define DEFAULT_CORNER_RADIUS 10

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
	_imageView = [[UIImageView alloc] initWithFrame:
				  CGRectMake(floorf((self.frame.size.width  - _image.size.width )/2),
							 floorf((self.frame.size.height - _image.size.height)/2) - 14,
							 _image.size.width,
							 _image.size.height)];
	_imageView.autoresizingMask = UIViewAutoresizingFlexibleMargins;
	_imageView.image = _image;
	[self addSubview:_imageView];
	
	// Default text size
	_textSize = 16;
	
	// Text
	_textView = [[UILabel alloc] init];
	_textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_textView.text = _text;
	_textView.backgroundColor = [UIColor clearColor];
	_textView.textColor = [UIColor whiteColor];
	_textView.numberOfLines = 1;
	_textView.textAlignment = NSTextAlignmentCenter;
	_textView.shadowColor = [UIColor clearColor];
	_textView.font = [UIFont boldSystemFontOfSize:_textSize];
	[self addSubview:_textView];
}

- (void)setImage:(UIImage *)image
{
	_image = image;
	_imageView.image = _image;
	_imageView.frame = CGRectMake(floorf((self.frame.size.width  - _image.size.width )/2),
								  floorf((self.frame.size.height - _image.size.height)/2) + 14,
								  _image.size.width,
								  _image.size.height);
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
	[[UIColor colorWithWhite:0.0f alpha:0.77f] setFill];
	[bp fill];
}

- (void)display
{
	[self.layer removeAllAnimations];
	[[self class] cancelPreviousPerformRequestsWithTarget:self];
	self.alpha = 1.0f;
	[self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.0f];
}

- (void)fadeOut
{
	CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOut.fromValue = @1.0f;
	fadeOut.toValue = @0.0f;
	fadeOut.duration = 0.75f;
	[self.layer addAnimation:fadeOut forKey:@"alpha"];
	self.alpha = 0.0f;
}

@end
