//
//  PCDField.h
//  Passcode
//
//  Created by Matt Zanchelli on 7/6/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTZTextField.h"

@interface PCDField IB_DESIGNABLE : UIView

/// The label to display on the left side of the field.
@property (strong, nonatomic) UILabel *titleLabel;

/// The text field.
@property (strong, nonatomic) MTZTextField *textField;

/// The width for the title label.
@property (nonatomic) IBInspectable CGFloat titleLabelWidth;

@end
