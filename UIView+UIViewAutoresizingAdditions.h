//
//  UIView+UIViewAutoresizingAdditions.h
//  Passcode
//
//  Created by Matt Zanchelli on 4/20/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIViewAutoresizingFlexibleDimensions (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
#define UIViewAutoresizingFlexibleMargins (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin)

@interface UIView (UIViewAutoresizingAdditions)

@end
