//
//  MTZFarPanGestureRecognizer.h
//
//  Created by Matt on 5/26/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef NS_ENUM(NSInteger, MTZFarPanDistanceType) {
	MTZFarPanDistanceTypeHorizontal,	// X
	MTZFarPanDistanceTypeVertical,		// Y
	MTZFarPanDistanceTypeTotal			// sqrt(X^2 + Y^2)
};

@interface MTZFarPanGestureRecognizer : UIPanGestureRecognizer

// Set how the minimum required panning distance is calculated
@property MTZFarPanDistanceType distanceType;

// The minimum number of points required for the recognizer
// to move to UIGestureRecognizerStateChanged
@property CGFloat minimumRequiredPanningDistance;

// Did the user pan far enough?
@property BOOL didPanFarEnough;;

@end
