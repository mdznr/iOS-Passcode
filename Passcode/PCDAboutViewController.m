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

- (IBAction)done:(id)sender;
- (IBAction)howToUsePressed:(id)sender;
- (IBAction)faqPressed:(id)sender;
- (IBAction)supportPressed:(id)sender;
- (IBAction)writeAReviewPressed:(id)sender;

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
	
	// Listen to UIContentSizeCategoryDidChangeNotification (Dynamic Type).
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(preferredContentSizeDidChange:)
												 name:UIContentSizeCategoryDidChangeNotification
											   object:nil];
	
	self.title = NSLocalizedString(@"About", nil);
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
															 style:UIBarButtonItemStyleDone
															target:self
															action:@selector(done:)];
	self.navigationItem.leftBarButtonItem = done;
}

- (void)preferredContentSizeDidChange:(id)sender
{
	[self.tableView reloadData];
}

- (IBAction)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger indexes[indexPath.length];
	[indexPath getIndexes:indexes];
	NSUInteger section = indexes[0];
	
#warning Wish there was a better solution than hardcoding section 0,2
	
	UIFont *font;
	BOOL calculateHeight = NO;
	switch ( section ) {
#warning Wish there was a better solution than hardcoding text styles
		case 0:
			// About
			font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
			calculateHeight = YES;
			break;
		case 2:
			// Credits
			font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
			calculateHeight = YES;
		default:
			break;
	}
	
	// Calculate height.
	if ( calculateHeight ) {
		UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
		NSString *text = cell.textLabel.text;
		CGFloat width = cell.textLabel.frame.size.width;
		NSDictionary *attrs = @{NSFontAttributeName: font};
		CGRect rect = [text boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
										 options:NSStringDrawingUsesLineFragmentOrigin
									  attributes:attrs
										 context:nil];
		return ceil(rect.size.height) + 24;
	}
	
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUInteger indexes[indexPath.length];
	[indexPath getIndexes:indexes];
	NSUInteger section = indexes[0];
	
#warning Wish there was a better solution than hardcoding section 0,2
	UIFont *font;
	BOOL updateFont = NO;
	switch ( section ) {
#warning Wish there was a better solution than hardcoding text styles
		case 0:
			// About
			font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
			updateFont = YES;
			break;
		case 2:
			// Credits
			font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
			updateFont = YES;
			break;
		default:
			break;
	}
	
	// Update the cell's font.
	if ( updateFont ) {
		UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
		cell.textLabel.font = font;
		return cell;
	}
	
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	// Deselect cell.
	[[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	
	// Navigate accordingly.
	switch ( indexPath.row ) {
		case 0:
			[self howToUsePressed:self];
			break;
		case 1:
			[self faqPressed:self];
			break;
		case 2:
			[self supportPressed:self];
			break;
		case 3:
			[self writeAReviewPressed:self];
			break;
		default:
			break;
	}
}


#pragma mark Actions

- (IBAction)howToUsePressed:(id)sender
{
#warning How to Use Passcode
}

- (IBAction)faqPressed:(id)sender
{
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PCDFAQViewController" bundle:nil];
	PCDFAQViewController *faq = [sb instantiateViewControllerWithIdentifier:@"PCDFAQViewController"];
#if DEBUG
	faq.remoteURL = @"http://mdznr.com/FAQs.plist";
#else
	faq.remoteURL = @"https://raw.github.com/mdznr/iOS-Passcode/master/FAQs.plist";
#endif
	faq.fileName = @"FAQs";
	[self.navigationController pushViewController:faq animated:YES];
}

- (IBAction)supportPressed:(id)sender
{
	if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
		
        NSArray *toRecipients = @[@"passcode@mdznr.com"];
        [mailer setToRecipients:toRecipients];
        [mailer setSubject:NSLocalizedString(@"Passcode Support", nil)];
		
		[mailer setModalPresentationStyle:UIModalPresentationPageSheet];
		[self presentViewController:mailer animated:YES completion:^{}];
    } else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://passcod.es/support"]];
    }
}

- (IBAction)writeAReviewPressed:(id)sender
{
	// Check if SKStoreProductViewController is available (iOS 6 and later).
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


#pragma mark MFMailComposeViewControllerDelgate

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	switch ( result ) {
		case MFMailComposeResultCancelled:
			// Support Email Cancelled
			break;
		case MFMailComposeResultFailed:
			// Support Email Failed
			break;
		case MFMailComposeResultSaved:
			// Support Email Saved
			break;
		case MFMailComposeResultSent:
			// Support Email Sent
			break;
		default:
			break;
	}
	
	[self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
