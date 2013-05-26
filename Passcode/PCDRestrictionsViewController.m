//
//  PCDRestrictionsViewController.m
//  Passcode
//
//  Created by Matt on 5/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDRestrictionsViewController.h"

@interface PCDRestrictionsViewController ()

@end

@implementation PCDRestrictionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	self.title = NSLocalizedString(@"Restrictions", @"Restrictions");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Done button to dismiss view controller
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
	[self.navigationItem setLeftBarButtonItem:done];
	
	// Invisible right bar button to also dismiss view controller
	UIButton *invisible = [UIButton buttonWithType:UIButtonTypeCustom];
	[invisible setTitle:done.title forState:UIControlStateNormal];
	// Would be nice not having to hard-code in width and height
	[invisible setFrame:CGRectMake(0, 0, 55, 32)];
	[invisible setShowsTouchWhenHighlighted:YES];
	UIBarButtonItem *secretlyDone = [[UIBarButtonItem alloc] initWithCustomView:invisible];
	[invisible addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationItem setRightBarButtonItem:secretlyDone];
}

- (void)done:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
