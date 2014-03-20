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

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *text;
@property (nonatomic) CGFloat textSize;

- (void)display;

@end
