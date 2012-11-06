//
//  MailComposeDelegate.m
//  Passcode
//
//  Created by Matt on 11/5/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "MailComposeDelegate.h"

@implementation MailComposeDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch ( result )
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Failed");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Sent");
			break;
		default:
			break;
	}
}

@end
