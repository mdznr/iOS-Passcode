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

///	The image to display in the view.
@property (strong, nonatomic) UIImage *image;

///	The text to display below the image.
@property (strong, nonatomic) NSString *text;

///	The size of the text.
@property (nonatomic) CGFloat textSize;

///	Display the view.
- (void)display;

@end
