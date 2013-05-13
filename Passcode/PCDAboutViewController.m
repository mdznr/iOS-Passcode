//
//  PCDAboutViewController.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCDAboutViewController.h"
#import "PCDFAQViewController.h"
#import <StoreKit/StoreKit.h>

@interface PCDAboutViewController () <SKStoreProductViewControllerDelegate>

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
	
	self.title = NSLocalizedString(@"About", nil);
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
																   style:UIBarButtonItemStyleDone
																  target:self
																  action:@selector(done:)];
	self.navigationItem.leftBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
	if ( self.delegate ) {
		[self.delegate dismissingModalViewController:self];
	} else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	
}

- (IBAction)howToUsePressed:(id)sender
{
	if ( self.delegate ) {
		[self.delegate startWalkthrough:self];
	} else {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (IBAction)faqPressed:(id)sender
{
	PCDFAQViewController *faq = [[PCDFAQViewController alloc] init];
#if DEBUG
	[faq setRemoteURL:@"http://mdznr.com/FAQs.plist"];
#else
	[faq setRemoteURL:@"https://raw.github.com/mdznr/iOS-Passcode/master/FAQs.plist"];
#endif
	[faq setFileName:@"FAQs"];
	[self.navigationController pushViewController:faq animated:YES];
}

#pragma mark Support Email

- (IBAction)supportPressed:(id)sender
{
	if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
		
        NSArray *toRecipients = [NSArray arrayWithObjects:@"passcode@mdznr.com", nil];
        [mailer setToRecipients:toRecipients];
        [mailer setSubject:NSLocalizedString(@"Passcode Support", nil)];
		
		[mailer.navigationBar setTintColor:[UIColor colorWithRed:25.0f/255.0f green:52.0f/255.0f blue:154.0f/255.0f alpha:1.0f]];
		
		[mailer setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentModalViewController:mailer animated:YES];
    } else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://passcod.es/support"]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch ( result ) {
		case MFMailComposeResultCancelled:
//			NSLog(@"Support Email Cancelled");
			break;
		case MFMailComposeResultFailed:
//			NSLog(@"Support Email Failed");
			break;
		case MFMailComposeResultSaved:
//			NSLog(@"Support Email Saved");
			break;
		case MFMailComposeResultSent:
//			NSLog(@"Support Email Sent");
			break;
		default:
			break;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)writeAReviewPressed:(id)sender
{
	// Check if SKStoreProductViewController is available (iOS 6 and later)
	if ( NSStringFromClass([SKStoreProductViewController class]) != nil ) {
		SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
        storeViewController.delegate = self;
		
        NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:@554389206};
		
        [storeViewController loadProductWithParameters:parameters completionBlock:nil];
		[self presentViewController:storeViewController animated:YES completion:nil];
	} else {
		NSURL *appStoreURL = [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=554389206"];
		[[UIApplication sharedApplication] openURL:appStoreURL];
	}
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

#pragma mark -
#pragma mark SKStoreProductViewControllerDelegate

-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
