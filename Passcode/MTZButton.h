//
//  MTZButton.h
//  Passcode
//
//  Created by Matt Zanchelli on 5/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZButton : UIButton

///	The radius of the button's corners.
@property (nonatomic) CGFloat cornerRadius;

///	Returns the color of the top of the button associated with the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
///	@return The color on the top of the button for the specified state. If no color has been set for the specific state, this method returns the top color associated with the @c UIControlStateNormal state.
- (UIColor *)topColorForState:(UIControlState)state;

///	Sets the color of the top of the button to use for the specified state.
///	@param color The color of the top of the button to use for the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
- (void)setTopColor:(UIColor *)color forState:(UIControlState)state;

///	Returns the color of the bottom of the button associated with the specified state.
///	@param state The state that uses the title. The possible values are described in @c UIControlState.
///	@return The color on the bottom of the button for the specified state. If no color has been set for the specific state, this method returns the bottom color associated with the @c UIControlStateNormal state.
- (UIColor *)bottomColorForState:(UIControlState)state;

///	Sets the color of the bottom of the button to use for the specified state.
///	@param color The color of the bottom of the button to use for the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
- (void)setBottomColor:(UIColor *)color forState:(UIControlState)state;

///	Returns the color of the border associated with the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
///	@return The color of the border of the button for the specified state.
- (UIColor *)borderColorForState:(UIControlState)state;

///	Sets the color of the border of the button to use for the specified state.
///	@param color The color of the border of the button to use for the specified state.
///	@param state The state that uses the specified color. The possible values are described in @c UIControlState.
- (void)setBorderColor:(UIColor *)color forState:(UIControlState)state;

@end
