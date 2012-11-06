//
//  AboutViewController.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)howToUse
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mdznr.com/passcode/howto"]];
}

- (IBAction)faq
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mdznr.com/passcode/faq"]];
}

#pragma mark Support Email

- (IBAction)showSupport
{
	if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
		
        mailer.mailComposeDelegate = self;
		
        [mailer setSubject:@"Passcode Support"];
        NSArray *toRecipients = [NSArray arrayWithObjects:@"passcode@mdznr.com", nil];
        [mailer setToRecipients:toRecipients];
		
		// Is there a way to hide the Cc/Bcc lines?
		[mailer setBccRecipients:nil];
		[mailer setCcRecipients:nil];
		
//        NSString *emailBody = @"";
//        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mdznr.com/passcode/support"]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch ( result )
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Support Email Cancelled");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Support Email Failed");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Support Email Saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Support Email Sent");
			break;
		default:
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Writing a Review

- (IBAction)writeAReview
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=554389206"]];
}

- (void)viewDidUnload
{
	[self setNavigationBar:nil];
	[super viewDidUnload];
}
@end
