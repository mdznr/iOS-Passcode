//
//  MTZButton.m
//  Passcode
//
//  Created by Matt Zanchelli on 5/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "MTZButton.h"

#define DEFAULT_CORNER_RADIUS 8

@interface MTZButton ()

@property (strong, nonatomic) NSMutableDictionary *topColorsForStates;
@property (strong, nonatomic) NSMutableDictionary *bottomColorsForStates;

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
	_topColorsForStates = [[NSMutableDictionary alloc] initWithCapacity:6];
	_bottomColorsForStates = [[NSMutableDictionary alloc] initWithCapacity:6];
	
	[self addTarget:self action:@selector(updateBorder) forControlEvents:UIControlEventAllEvents];
}


#pragma mark - Properties

- (void)setCornerRadius:(CGFloat)cornerRadius
{
	_cornerRadius = cornerRadius;
	[self setNeedsDisplay];
}

///	Returns the color of the top of the button associated with the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
///	@return The color on the top of the button for the specified state. If no color has been set for the specific state, this method returns the top color associated with the @c UIControlStateNormal state.
- (UIColor *)topColorForState:(UIControlState)state
{
	return _topColorsForStates[keyForControlState(state)];
}

///	Sets the color of the top of the button to use for the specified state.
///	@param color The color of the top of the button to use for the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
- (void)setTopColor:(UIColor *)color forState:(UIControlState)state
{
	_topColorsForStates[keyForControlState(state)] = color;
	[self updateBackgroundImageForControlState:state];
}

///	Returns the color of the bottom of the button associated with the specified state.
///	@param state The state that uses the title. The possible values are described in @c UIControlState.
///	@return The color on the bottom of the button for the specified state. If no color has been set for the specific state, this method returns the bottom color associated with the @c UIControlStateNormal state.
- (UIColor *)bottomColorForState:(UIControlState)state
{
	return _bottomColorsForStates[keyForControlState(state)];
}

///	Sets the color of the bottom of the button to use for the specified state.
///	@param color The color of the bottom of the button to use for the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
- (void)setBottomColor:(UIColor *)color forState:(UIControlState)state
{
	_bottomColorsForStates[keyForControlState(state)] = color;
	[self updateBackgroundImageForControlState:state];
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
	
	switch ( self.state ) {
		case UIControlStateDisabled:
			self.layer.borderWidth = 0.75f;
			self.layer.borderColor = [UIColor colorWithRed:213.0f/255.0f green:217.0f/255.0f blue:223.0f/255.0f alpha:1.0f].CGColor;
			break;
		default:
			self.layer.borderWidth = 0.0f;
			self.layer.borderColor = [UIColor clearColor].CGColor;
			break;
	}
}


@end
