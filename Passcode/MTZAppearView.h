//
//  MTZAppearView.h
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MTZAppearView : UIView

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *text;
@property (nonatomic) CGFloat textSize;

- (void)display;

@end
