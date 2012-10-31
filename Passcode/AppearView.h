//
//  AppearView.h
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AppearView : UIView

@property NSString *imageName;
@property NSString *text;
@property CGFloat textSize;

- (void)display;

@end
