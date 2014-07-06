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

/// Set the name of the service.
- (void)setServiceName:(NSString *)serviceName;

@end
