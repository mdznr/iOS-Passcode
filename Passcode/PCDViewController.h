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
#import "MTZSlideToReveal.h"

@interface PCDViewController : UIViewController

#pragma mark Domain

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UITextField *domainField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *generateButton;
@property (strong, nonatomic) IBOutlet MTZSlideToReveal *reveal;
@property (strong, nonatomic) MTZAppearWindow *copiedWindow;

- (void)checkPasteboard;
- (void)checkSecuritySetting;
- (IBAction)generateAndCopy:(id)sender;
- (IBAction)viewAbout:(id)sender;
- (IBAction)textDidChange:(id)sender;

@end
