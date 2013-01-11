//
//  PCDAboutViewController.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCDAboutViewController.h"

@interface PCDAboutViewController ()

@end

@implementation PCDAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if ( self ) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"About";
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
	self.navigationItem.leftBarButtonItem = doneButton;
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

- (IBAction)howToUsePressed:(id)sender
{
	PCDWalkthroughViewController *walkthrough = [[PCDWalkthroughViewController alloc] initWithNibName:@"PCDWalkthroughViewController" bundle:nil];
	[self.navigationController pushViewController:walkthrough animated:YES];
}

- (IBAction)faqPressed:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mdznr.com/passcode/faq"]];
}

#pragma mark Support Email

- (IBAction)supportPressed:(id)sender
{
	if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
		
        NSArray *toRecipients = [NSArray arrayWithObjects:@"passcode@mdznr.com", nil];
        [mailer setToRecipients:toRecipients];
        [mailer setSubject:@"Passcode Support"];
		
		[mailer.navigationBar setTintColor:[UIColor colorWithRed:25.0f/255.0f green:52.0f/255.0f blue:154.0f/255.0f alpha:1.0f]];
		
		//		[[self navigationController] pushViewController:mailer animated:YES];	// Perhaps eventually do something like this instead?
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
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

- (IBAction)writeAReviewPressed:(id)sender
{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=554389206"]];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}
@end
