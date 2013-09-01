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
    if (self)
	{
		[self setup];
    }
    return self;
}

- (id)init
{
	CGRect frame = CGRectMake(0, 0, 128, 128);
	return self = [self initWithFrame:frame];
}

- (void)setup
{
	//  Created by Jeff LaMarche on 11/13/08.
	//	via http://iphonedevelopment.blogspot.com/2008/11/creating-transparent-uiviews-rounded.html
	
	// Roundrect
	/*
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHue:0.0f
													   saturation:0.0f
													   brightness:0.0f
															alpha:0.7f].CGColor);
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = DEFAULT_CORNER_RADIUS;
    CGFloat width = CGRectGetWidth(rrect);
    CGFloat height = CGRectGetHeight(rrect);
    
    // Make sure corner radius isn't larger than half the shorter side
    if (radius > width/2.0) radius = width/2.0;
    if (radius > height/2.0) radius = height/2.0;
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
	
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat midy = CGRectGetMidY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect);
	
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
	*/
	
	UIGraphicsBeginImageContext(self.bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHue:0.0f
													   saturation:0.0f
													   brightness:0.0f
															alpha:0.7f].CGColor);
	UIBezierPath *roundRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
														 cornerRadius:DEFAULT_CORNER_RADIUS];
	CGContextDrawPath(context, kCGPathFillStroke);
	UIGraphicsEndImageContext();
	
	self.backgroundColor = UIColor.blueColor;
	
	UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 128)];
	test.backgroundColor = UIColor.clearColor;
	test.opaque = NO;
	test.text = @"TESTING THIS";
	[self addSubview:test];
	
	// Image
	UIImage *image = [UIImage imageNamed:_imageName];
	_imageView = [[UIImageView alloc] initWithFrame:
				  CGRectMake(floorf((self.frame.size.width - image.size.width)/2),
							 floorf((self.frame.size.height - image.size.height)/2) - 14,
							 image.size.width,
							 image.size.height)];
	_imageView.image = image;
	[self addSubview:_imageView];
	
	// Text
	_textView = [[UILabel alloc] initWithFrame:CGRectMake(0,
														  self.frame.size.height/2 + 9,
														  self.frame.size.width,
														  self.frame.size.height/2)];
	_textView.text = _text;
	_textView.backgroundColor = [UIColor clearColor];
	_textView.textColor = [UIColor whiteColor];
	_textView.textAlignment = NSTextAlignmentCenter;
	_textView.shadowColor = [UIColor blackColor];
	_textView.shadowOffset = CGSizeMake(0, 1);
	_textView.font = [UIFont boldSystemFontOfSize:_textSize];
	[self addSubview:_textView];
}

- (void)setImageName:(NSString *)imageName
{
	_imageName = imageName;
	_imageView.image = [UIImage imageNamed:imageName];
	_imageView.center = self.center;
}

- (void)setText:(NSString *)text
{
	_text = text;
	_textView.text = text;
}

- (void)setTextSize:(CGFloat)textSize
{
	_textSize = textSize;
	_textView.font = [UIFont boldSystemFontOfSize:textSize];
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
