//
//  AboutNavigationController.m
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "AboutNavigationController.h"

@interface AboutNavigationController ()

@end

@implementation AboutNavigationController

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
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)howToUse
{
	
}

- (IBAction)faq
{
	NSLog(@"FAQ REQUESTED");
	FAQ *faq = [[FAQ alloc] init];
	[self presentModalViewController:faq animated:YES];
}

- (IBAction)showSupport
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://mdznr.com/passcode"]];
}

- (void)viewDidUnload
{
	[self setNavigationBar:nil];
	[super viewDidUnload];
}
@end
