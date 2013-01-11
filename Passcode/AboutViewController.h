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

#import "WalkthroughViewController.h"

@interface AboutViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)done:(id)sender;
- (IBAction)howToUsePressed:(id)sender;
- (IBAction)faqPressed:(id)sender;
- (IBAction)supportPressed:(id)sender;
- (IBAction)writeAReviewPressed:(id)sender;

@end
