//
//  MTZAppearWindow.h
//  Passcode
//
//  Created by Matt on 8/31/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MTZAppearWindow : UIWindow

///	The image to display in the appear view.
@property (strong, nonatomic) UIImage *image;

///	The text to have in the appear view's label.
@property (strong, nonatomic) NSString *text;

///	The size of the text in the appear view's label.
@property (nonatomic) CGFloat textSize;

///	Display the appear view. It will automatically hide after a duration.
- (void)display;

@end
