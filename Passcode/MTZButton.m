//
//  MTZButton.m
//  Passcode
//
//  Created by Matt Zanchelli on 5/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "MTZButton.h"

#define DEFAULT_CORNER_RADIUS 8
#define DEFAULT_BORDER_WIDTH 0.75f

@interface MTZButton ()

@property (strong, nonatomic) NSMutableDictionary *topColorsForStates;
@property (strong, nonatomic) NSMutableDictionary *bottomColorsForStates;
@property (strong, nonatomic) NSMutableDictionary *borderColorsForStates;

@end

@implementation MTZButton


#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( !self ) { return self; }
	
	[self _setUpMTZButton];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( !self ) { return self; }
	
	[self _setUpMTZButton];
    return self;
}

- (id)init
{
    self = [super init];
    if ( !self ) { return self; }
	
	[self _setUpMTZButton];
    return self;
}

- (void)_setUpMTZButton
{
	_cornerRadius = DEFAULT_CORNER_RADIUS;
	
	NSUInteger capacity = 6;
	_topColorsForStates = [[NSMutableDictionary alloc] initWithCapacity:capacity];
	_bottomColorsForStates = [[NSMutableDictionary alloc] initWithCapacity:capacity];
	_borderColorsForStates = [[NSMutableDictionary alloc] initWithCapacity:capacity];
	
	[self addTarget:self action:@selector(updateBorder) forControlEvents:UIControlEventAllEvents];
}


#pragma mark - Properties

- (void)setCornerRadius:(CGFloat)cornerRadius
{
	_cornerRadius = cornerRadius;
	[self setNeedsDisplay];
}

- (UIColor *)topColorForState:(UIControlState)state
{
	return _topColorsForStates[keyForControlState(state)];
}

- (void)setTopColor:(UIColor *)color forState:(UIControlState)state
{
	_topColorsForStates[keyForControlState(state)] = color;
	[self updateBackgroundImageForControlState:state];
}

- (UIColor *)bottomColorForState:(UIControlState)state
{
	return _bottomColorsForStates[keyForControlState(state)];
}

- (void)setBottomColor:(UIColor *)color forState:(UIControlState)state
{
	_bottomColorsForStates[keyForControlState(state)] = color;
	[self updateBackgroundImageForControlState:state];
}

- (UIColor *)borderColorForState:(UIControlState)state
{
	return _borderColorsForStates[keyForControlState(state)];
}

- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state
{
	_borderColorsForStates[keyForControlState(state)] = color;
	[self updateBorder];
}


#pragma mark - Helpers

NSString *keyForControlState(UIControlState state)
{
	return [[NSNumber numberWithUnsignedInteger:state] stringValue];
}

- (void)updateBackgroundImageForControlState:(UIControlState)state
{
	NSString *controlStateKey = keyForControlState(state);
	UIColor *topColor = _topColorsForStates[controlStateKey];
	UIColor *bottomColor = _bottomColorsForStates[controlStateKey];
	
	if ( !topColor && !bottomColor ) {
		[self setBackgroundImage:nil forState:state];
		return;
	}
	
	if ( !bottomColor ) {
		bottomColor = topColor;
	} else if ( !topColor ) {
		topColor = bottomColor;
	}
	
	NSArray *gradientColors = @[(id)topColor.CGColor, (id)bottomColor.CGColor];
	CGFloat gradientLocations[2] = {0.0f, 1.0f};
	CGColorSpaceRef colorSpace = CGColorGetColorSpace((CGColorRef) gradientColors[0]);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
	
	UIGraphicsBeginImageContext(CGSizeMake(1, self.frame.size.height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(0.0f, self.frame.size.height), kNilOptions);
	
	UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
	[self setBackgroundImage:backgroundImage forState:state];
}

- (void)updateBorder
{
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	self.layer.cornerRadius = self.cornerRadius;
	self.layer.masksToBounds = YES;
	self.layer.borderWidth = DEFAULT_BORDER_WIDTH;
	
	UIColor *borderColor = [self borderColorForState:self.state];
	if ( !borderColor ) borderColor = [UIColor clearColor];
	self.layer.borderColor = borderColor.CGColor;
}


@end
