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
	
	_scrollView.contentSize = CGSizeMake(320,
										 _howTo.frame.size.height
										 +_tips.frame.size.height);
	
	[_passcodeURL setTitleColor:[UIColor colorWithRed:14.0f/255.0f
												green:50.0f/255.0f
												 blue:110.0f/255.0f
												alpha:1]
					   forState:UIControlStateHighlighted];
	
	// Change tips text depending on current setting.
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] )
	{
		_tips.text = @"No data is ever sent to or from this device from the internet.\n\nPasscode is also available for Safari and via the web at\n\nTips:\n\nOpen the app with a URL in your clipboard, and Passcode automatically fills out the domain field.\n\nYou can prevent Passcode from remembering your master password in Settings.";
	}
	else
	{
		_tips.text = @"No data is ever sent to or from this device from the internet.\n\nPasscode is also available for Safari and via the web at\n\nTips:\n\nOpen the app with a URL in your clipboard, and Passcode automatically fills out the domain field.\n\nYou can allow Passcode to remember your master password in Settings.";
	}
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

- (void)viewDidUnload {
	[self setHowTo:nil];
	[self setTips:nil];
	[self setPasscodeURL:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
}
@end
