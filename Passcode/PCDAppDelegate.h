//
//  PCDAppDelegate.h
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCDViewController;

@interface PCDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PCDViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
