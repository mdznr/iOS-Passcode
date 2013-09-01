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

@property NSString *imageName;
@property NSString *text;
@property CGFloat textSize;

- (void)display;

@end
