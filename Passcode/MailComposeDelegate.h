//
//  MailComposeDelegate.h
//  Passcode
//
//  Created by Matt on 11/5/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MailComposeDelegate : NSObject <MFMailComposeViewControllerDelegate>

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
