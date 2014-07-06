//
//  PCDViewController.h
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCDAboutViewController.h"
#import "PCDRestrictionsViewController.h"

#import "MTZAppearWindow.h"
#import "MTZButton.h"
#import "MTZSlideToReveal.h"
#import "MTZTextField.h"

@interface PCDViewController : UIViewController

///
- (void)setDomain:(NSString *)domain;

- (void)checkPasteboard;
- (void)checkSecuritySetting;

@end
