//
//  PCDViewController.h
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCDAboutViewController.h"

#import "MTZAppearView.h"
#import "MTZWalkthroughPagesView.h"
#import "PCDAboutViewControllerDelegate.h"

@interface PCDViewController : UIViewController <PCDAboutViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UITextField *domainField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *generateButton;
@property (strong, nonatomic) IBOutlet MTZAppearView *copiedView;

// Walthrough
@property (strong, nonatomic) IBOutlet MTZWalkthroughPagesView *pagesView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *page1, *page2, *page3, *page4, *page5;

- (void)checkPasteboard;
- (void)checkSecuritySetting;
- (IBAction)generateAndCopy:(id)sender;
- (IBAction)viewAbout:(id)sender;
- (IBAction)textDidChange:(id)sender;

- (void)animateForMasterPassword;
- (void)animateForDomain;
- (void)animateForGenerate;

@end
