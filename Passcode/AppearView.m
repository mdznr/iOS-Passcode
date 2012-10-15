//
//  AppearView.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "AppearView.h"

#define CORNER_RADIUS 8

@implementation AppearView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		[self drawRect:frame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	//  Created by Jeff LaMarche on 11/13/08.
	//	via http://iphonedevelopment.blogspot.com/2008/11/creating-transparent-uiviews-rounded.html
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHue:0.0f
													   saturation:0.0f
													   brightness:0.0f
															alpha:0.5f].CGColor);
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = CORNER_RADIUS;
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
	
	UIImage *image = [UIImage imageNamed:_imageName];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:
							  CGRectMake(floorf((self.frame.size.width - image.size.width)/2),
										 floorf((self.frame.size.height - image.size.height)/2) - 12,
										 image.size.width,
										 image.size.height)];
	imageView.image = image;
	[self addSubview:imageView];
	
	UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0,
															  self.frame.size.height/2 + 8,
															  self.frame.size.width,
															  self.frame.size.height/2)];
	[text setText:NSLocalizedString(_text, nil)];
	text.backgroundColor = [UIColor clearColor];
	text.textColor = [UIColor whiteColor];
	text.textAlignment = NSTextAlignmentCenter;
	text.shadowColor = [UIColor blackColor];
	text.shadowOffset = CGSizeMake(1, 1);
	[text setFont:[UIFont boldSystemFontOfSize:16.0]];
	[self addSubview:text];
	
}

- (void)display
{
	[[self layer] removeAllAnimations];
	[[self class] cancelPreviousPerformRequestsWithTarget:self];
	[self setAlpha:1.0f];
	[self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.5f];
}

- (void)fadeOut
{
	CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[fadeOut setFromValue:@1.0f];
	[fadeOut setToValue:@0.0f];
	[fadeOut setDuration:1.0f];
	[[self layer] addAnimation:fadeOut forKey:@"alpha"];
	[self setAlpha:0.0f];
}

@end
