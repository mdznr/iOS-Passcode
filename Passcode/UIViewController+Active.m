//
//  UIViewController+Active.m
//  Passcode
//
//  Created by Matt Zanchelli on 7/6/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

@import UIKit;

@interface UIViewController (Active)

/// Can be sent to the currently presented controller when an application becomes active.
- (void)viewControllerDidBecomeActive;

@end
