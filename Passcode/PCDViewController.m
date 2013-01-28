//
//  PCDViewController.m
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

//	Copyright (c) 2012, individual contributors
//
//	Permission to use, copy, modify, and/or distribute this software for any
//	purpose with or without fee is hereby granted, provided that the above
//	copyright notice and this permission notice appear in all copies.
//
//	THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#import "PCDViewController.h"
#import "PDKeychainBindings.h"
#import "NSString+sha256.h"

@interface PCDViewController ()

@end

@implementation PCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
	self.title = @"Passcode";
	
	UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"About", nil)
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(viewAbout:)];
	self.navigationItem.leftBarButtonItem = aboutButton;
	
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:25.0f/255.0f
																		  green:52.0f/255.0f
																		   blue:154.0f/255.0f
																		  alpha:1.0f]];
	[_pagesView addPages:@[_page1, _page2, _page3, _page4]];
	[_pagesView setPageControl:_pageControl];
	
	[_pagesView performSelector:@selector(animateForMasterPassword) withObject:self whenStoppedOnPageIndex:0];
	[_pagesView performSelector:@selector(animateForDomain) withObject:self whenStoppedOnPageIndex:1];
	[_pagesView performSelector:@selector(animateForGenerate) withObject:self whenStoppedOnPageIndex:2];
	
	[_domainField becomeFirstResponder];
	[self checkSecuritySetting];
	
	// If running iOS 6.0 or higher, use smooth button resources, else glossy.
	BOOL smooth = NO;
	NSString *reqSysVer = @"6.0";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	if ( [ currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending ) {
		smooth = YES;
	}
	
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		// Set up Generate Button
		if ( smooth ) {
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonDisabled"] forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f
																   alpha:1.0f]
										forState:UIControlStateDisabled];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonEnabledGreen"]
									   forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:1.0f]
										forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonActiveGreen"]
									   forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:1.0f]
										forState:UIControlStateHighlighted];
		}
		else {
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonDisabledGlossy"]
									   forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f
																   alpha:1.0f]
										forState:UIControlStateDisabled];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonEnabledGreenGlossy"]
									   forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:0.5f]
										forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonActiveGreenGlossy"]
									   forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:0.5f]
										forState:UIControlStateHighlighted];
		}
		
		[_generateButton setTitleColor:[UIColor lightGrayColor]
							  forState:UIControlStateDisabled];
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateNormal];
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateHighlighted];
		// Should only be for disabled state
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0, 1);
	} else {
		// Set up Generate Button
		if ( smooth ) {
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonEnabledGreen"]
									   forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:1.0f]
										forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonActiveGreen"]
									   forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:1.0f]
										forState:UIControlStateHighlighted];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonDisabled"]
									   forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f
																   alpha:1.0f]
										forState:UIControlStateDisabled];
		} else {
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonEnabledGreenGlossy"]
									   forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:0.5f]
										forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonActiveGreenGlossy"]
									   forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:0.5f]
										forState:UIControlStateHighlighted];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonDisabled"]
									   forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f
																   alpha:1.0f]
										forState:UIControlStateDisabled];
		}
		
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateNormal];
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateHighlighted];
		[_generateButton setTitleColor:[UIColor lightGrayColor]
							  forState:UIControlStateDisabled];
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0,1);	// Should only be for disabled state
		
		[self registerForKeyboardNotifications];
	}
	
	/*
	// The beginnings of a cleaner, less distracting navigation bar
	[_navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
											[UIColor colorWithRed:60.0f/255.0f green:67.0f/255.0f blue:69.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
											[UIColor whiteColor], UITextAttributeTextShadowColor,
											[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
											nil]];
	*/
}

- (void)checkPasteboard
{
	if ( [[[UIPasteboard generalPasteboard] string] hasPrefix:@"http://"] || [[[UIPasteboard generalPasteboard] string] hasPrefix:@"https://"] )
	{
		NSURL *url = [[NSURL alloc] initWithString:[[UIPasteboard generalPasteboard] string]];
		NSArray *components = [[url host] componentsSeparatedByString:@"."];
		_domainField.text = components[[components count]-2];
		[self textDidChange:self];
	}
}

- (void)checkSecuritySetting
{
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == YES )
	{
		if ( [bindings objectForKey:@"passwordString"] )
			[_passwordField setText:[bindings objectForKey:@"passwordString"]];
	}
	else if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == NO )
	{
		[bindings setObject:@"" forKey:@"passwordString"];
		[_passwordField setText:@""];
	}
}

- (IBAction)generateAndCopy:(id)sender
{
	// Store the password in keychain
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	[bindings setObject:[_passwordField text] forKey:@"passwordString"];
	
	// Create the hash
	NSString *password = [[_domainField.text stringByAppendingString:_passwordField.text] sha256];
	
	// Copy it to pasteboard
	[[UIPasteboard generalPasteboard] setString:[password substringToIndex:16]];
	
	// Animation to show password has been copied
	[_copiedView display];
}

- (IBAction)viewAbout:(id)sender
{
	PCDAboutViewController *about = [[PCDAboutViewController alloc] initWithNibName:@"PCDAboutViewController"
																			 bundle:nil];
	[about setDelegate:self];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:about];
	[navigationController.navigationBar setTintColor:[UIColor colorWithRed:25.0f/255.0f
																	 green:52.0f/255.0f
																	  blue:154.0f/255.0f
																	 alpha:1.0f]];
	[navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
	[self presentViewController:navigationController animated:YES completion:nil];
	
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
		navigationController.view.superview.frame = CGRectMake(0, 0, 320, 460);
		navigationController.view.superview.center = self.view.center;
	}
}

- (void)dismissingModalViewController:(id)sender
{
	[sender dismissViewControllerAnimated:YES completion:nil];
	[_domainField becomeFirstResponder];
}

#pragma mark Walkthrough

- (void)startWalkthrough:(id)sender
{
	[sender dismissViewControllerAnimated:YES completion:nil];
	[_domainField resignFirstResponder];
	
	[_pagesView setHidden:NO];
	[_pageControl setHidden:NO];
}

- (void)animateForMasterPassword
{
	NSLog(@"animateForMasterPassword");
}

- (void)animateForDomain
{
	NSLog(@"animateForDomain");
}

- (void)animateForGenerate
{
	NSLog(@"animateForGenerate");
}

#pragma mark Text Field Delegate Methods

- (IBAction)textDidChange:(id)sender
{
	if ( (int) [[_domainField text] length] && (int) [[_passwordField text] length] ) {
		[_generateButton setEnabled:YES];
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0, -1);
	} else {
		[_generateButton setEnabled:NO];
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0, 1);
	}
}

- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
	if ( (int) [[_passwordField text] length] )
	{
		[_domainField setReturnKeyType:UIReturnKeyGo];
	}
	else
	{
		[_domainField setReturnKeyType:UIReturnKeyNext];
	}
	return YES;		// What does the return value do?
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ( (int) [[_domainField text] length] && (int) [[_passwordField text] length] ) {
		[self generateAndCopy:nil];
		return NO;
	} else if ( (int) [[_passwordField text] length] ) {
		return NO;
	}
	[_passwordField becomeFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Handle Keyboard Notifications

- (void)keyboardChanged:(id)object
{
	// Based on implentation in Genensis.
	// See License: https://raw.github.com/peterhajas/Genesis/master/License
	
    // Grab the dictionary out of the object
    NSDictionary* keyboardGeometry = [object userInfo];
    
    // Get the end frame rectangle of the keyboard
    NSValue* endFrameValue = [keyboardGeometry valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = [endFrameValue CGRectValue];
    
    // Convert the rect into view coordinates from the window, this accounts for rotation
    UIWindow* appWindow = [[[UIApplication sharedApplication] delegate] window];
    CGRect keyboardFrame = [[self view] convertRect:endFrame fromView:appWindow];
    
	// Our new frame will be centered within the width of the keyboard
	// and a height that is centered between the navBarHeight and the top of the keyboard (it's y origin)
	CGFloat keyboardWidth  = keyboardFrame.size.width;
	CGFloat keyboardHeight = keyboardFrame.origin.y;
	
	CGFloat width  = _container.frame.size.width;
	CGFloat height = _container.frame.size.height;
	
	CGRect newFrame = CGRectMake(floorl(ABS(keyboardWidth - width)/2),
								 floorl(ABS(keyboardHeight - height)/2),
								 width,
								 height);
	
	[_container setFrame:newFrame];
}

// Subscribe to keyboard notifications
- (void)registerForKeyboardNotifications
{
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardChanged:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
}

- (void)viewDidUnload
{
	[self setPasswordField:nil];
	[self setGenerateButton:nil];
	[self setCopiedView:nil];
	[self setContainer:nil];
	[self setView:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}
@end
