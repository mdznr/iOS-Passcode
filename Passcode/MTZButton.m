//
//  MTZButton.m
//  Passcode
//
//  Created by Matt Zanchelli on 5/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "MTZButton.h"

@interface MTZButton ()

@property (strong, nonatomic) NSMutableDictionary *topColorsForStates;
@property (strong, nonatomic) NSMutableDictionary *bottomColorsForStates;

@end

@implementation MTZButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)_setUpMTZButton
{
	_topColorsForStates = [[NSMutableDictionary alloc] initWithCapacity:6];
	_bottomColorsForStates = [[NSMutableDictionary alloc] initWithCapacity:6];
}

NSString *keyForControlState(UIControlState state)
{
	return [[NSNumber numberWithUnsignedInteger:state] stringValue];
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
}

@end
