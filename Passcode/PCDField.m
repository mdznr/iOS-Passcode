//
//  PCDField.m
//  Passcode
//
//  Created by Matt Zanchelli on 7/6/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "PCDField.h"

@interface PCDField ()

/// The constraint setting the width of @c titleLabel.
@property (strong, nonatomic) NSLayoutConstraint *titleLabelWidthConstraint;

@end


@implementation PCDField

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	CGFloat cornerRadius;
	CGFloat fontSize;
	CGFloat left, right, center;
	
	UITraitCollection *traitCollection = [UIScreen mainScreen].traitCollection;
	if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
		cornerRadius = 16.180339887498948482/2.0f;
		fontSize = 21.0f;
		left = 19;
		center = 14;
		right = 14;
	} else {
		cornerRadius = 16.180339887498948482/2.0f;
		fontSize = 16.0f;
		left = 12;
		center = 8;
		right = 8;
	}
	
	self.layer.cornerRadius = cornerRadius;
	self.layer.borderWidth = 0.5f;
	self.layer.borderColor = [UIColor colorWithHue:220.0f/360.0f saturation:0.03f brightness:0.87f alpha:1.0f].CGColor;
	
	// Label
	self.titleLabel = [[UILabel alloc] init];
	self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.titleLabel];
	
	self.titleLabel.textColor = [UIColor colorWithHue:0.6 saturation:0.04 brightness:0.87 alpha:1.0f];
	self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
	self.titleLabel.textAlignment = NSTextAlignmentLeft;
	self.titleLabel.numberOfLines = 1;
	
	// Text Field
	self.textField = [[MTZTextField alloc] init];
	self.textField.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.textField];
	
	self.textField.font = self.titleLabel.font;
	
	// Metrics
	NSDictionary *metrics = @{
							  @"left": @(left),
							  @"center": @(center),
							  @"right": @(right)
							  };
	
	NSDictionary *views = NSDictionaryOfVariableBindings(_titleLabel, _textField);
	
	// Constraints
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]|" options:0 metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField]|" options:0 metrics:metrics views:views]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[_titleLabel]-(center)-[_textField]-(right)-|" options:0 metrics:metrics views:views]];
	self.titleLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
	[self addConstraint:self.titleLabelWidthConstraint];
}


#pragma mark - Public API

- (void)setTitleLabelWidth:(CGFloat)titleLabelWidth
{
	self.titleLabelWidthConstraint.constant = titleLabelWidth;
}

- (CGFloat)titleLabelWidth
{
	return self.titleLabel.frame.size.width;
}

@end
