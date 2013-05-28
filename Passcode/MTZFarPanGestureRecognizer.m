//
//  MTZFarPanGestureRecognizer.m
//
//  Created by Matt on 5/26/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZFarPanGestureRecognizer.h"

@interface MTZFarPanGestureRecognizer ()

@end

@implementation MTZFarPanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event];
	
	CGFloat translation = ABS([self translationInView:self.view].x);
	if ( translation < _minimumRequiredPanningDistance ) {
		self.didPanFarEnough = YES;
	}
	switch ( self.state ) {
		case UIGestureRecognizerStateBegan:
		case UIGestureRecognizerStateChanged:
			if ( !self.didPanFarEnough ) {
				self.state = UIGestureRecognizerStatePossible;
			}
			break;
		default:
			break;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event];
}

- (void)reset
{
	self.didPanFarEnough = NO;
}

@end
