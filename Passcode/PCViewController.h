//
//  PCViewController.h
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "AppearView.h"

@interface PCViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UITextField *domainField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *generateButton;
@property (strong, nonatomic) IBOutlet AppearView *copiedView;
@property CGSize kbSize;

- (void)checkPasteboard;
- (void)checkSecuritySetting;
- (IBAction)generateAndCopy:(id)sender;
- (IBAction)viewAbout:(id)sender;

@end
