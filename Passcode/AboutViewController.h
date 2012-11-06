//
//  AboutViewController.h
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MailComposeDelegate.h"

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)done:(id)sender;
- (IBAction)howToUse;
- (IBAction)faq;
- (IBAction)showSupport;
- (IBAction)writeAReview;

@end
