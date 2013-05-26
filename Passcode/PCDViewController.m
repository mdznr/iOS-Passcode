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
#import "NSString+characterSwaps.h"

@interface PCDViewController () {
	BOOL isPresentingWalkthrough;
}

@end

@implementation PCDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
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
	
}

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
	
	UIBarButtonItem *restrictionsButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Restrictions", nil)
																		   style:UIBarButtonItemStyleBordered
																		  target:self
																		  action:@selector(viewRestrictions:)];
	self.navigationItem.rightBarButtonItem = restrictionsButton;
	
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:25.0f/255.0f
																		  green:52.0f/255.0f
																		   blue:154.0f/255.0f
																		  alpha:1.0f]];
	[_pagesView addPages:@[_page1, _page2, _page3, _page4, _page5]];
	[_pagesView setPageControl:_pageControl];
	
	[_domainField becomeFirstResponder];
	[self checkSecuritySetting];
	
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
	{
		// Set up Generate Button
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonDisabled"]
									   forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f
																   alpha:1.0f]
										forState:UIControlStateDisabled];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonGreenEnabled"]
									   forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:1.0f]
										forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonGreenActive"]
									   forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f
																 green:61.0f/255.0f
																  blue:39.0f/255.0f
																 alpha:1.0f]
										forState:UIControlStateHighlighted];
		
		[_generateButton setTitleColor:[UIColor colorWithWhite:0.75f alpha:1.0f]
							  forState:UIControlStateDisabled];
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateNormal];
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateHighlighted];
		
		// Should only be for disabled state
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0, 1);
	}
	else
	{
		// Set up Generate Button
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
		
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateNormal];
		[_generateButton setTitleColor:[UIColor whiteColor]
							  forState:UIControlStateHighlighted];
		[_generateButton setTitleColor:[UIColor lightGrayColor]
							  forState:UIControlStateDisabled];
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0,1);	// Should only be for disabled state
		
		[self registerForKeyboardNotifications];
	}
	
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	[_generateButton addGestureRecognizer:longPressGesture];
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	[_generateButton addGestureRecognizer:panGesture];
	
	[_reveal setHidden:YES];
	
	/*
	// The beginnings of a cleaner, less distracting navigation bar
	[_navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
											[UIColor colorWithRed:60.0f/255.0f green:67.0f/255.0f blue:69.0f/255.0f alpha:1.0f], UITextAttributeTextColor,
											[UIColor whiteColor], UITextAttributeTextShadowColor,
											[NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
											nil]];
	*/
}

- (void)viewDidAppear:(BOOL)animated
{
	// Display About if app hasn't been launched before
	if ( ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedAppBefore"] ) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedAppBefore"];
		[self viewAbout:self];
	}
}

- (NSUInteger)supportedInterfaceOrientations
{
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		return UIInterfaceOrientationMaskPortrait;
    } else {
		return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		return toInterfaceOrientation == UIInterfaceOrientationPortrait;
    } else {
		return YES;
    }
}

- (void)checkPasteboard
{
	if ( [[[UIPasteboard generalPasteboard] string] hasPrefix:@"http://"] ||
		 [[[UIPasteboard generalPasteboard] string] hasPrefix:@"https://"] ) {
		NSURL *url = [[NSURL alloc] initWithString:[[UIPasteboard generalPasteboard] string]];
		NSArray *components = [[url host] componentsSeparatedByString:@"."];
		_domainField.text = components[[components count]-2];
		[self textDidChange:self];
	}
}

- (void)checkSecuritySetting
{
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == YES ) {
		if ( [bindings objectForKey:@"passwordString"] )
			[_passwordField setText:[bindings objectForKey:@"passwordString"]];
	}
	else if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == NO ) {
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
	NSString *concatination = [[_domainField.text lowercaseString] stringByAppendingString:_passwordField.text];
	NSData *passwordData = [concatination sha256Data];
	NSString *password = [NSString base64StringFromData:passwordData];
	
	// Now replace + and / with ! and # to improve password compatibility
	password = [password stringByReplacingOccurrencesOfCharacter:'+' withCharacter:'!'];
	password = [password stringByReplacingOccurrencesOfCharacter:'/' withCharacter:'#'];
	
	// Copy it to pasteboard
	[[UIPasteboard generalPasteboard] setString:[password substringToIndex:16]];
	
	// Animation to show password has been copied
	[_copiedView display];
}

- (void)generateAndSetReveal:(id)sender
{
	// Create the hash
	NSString *concatination = [[_domainField.text lowercaseString] stringByAppendingString:_passwordField.text];
	NSData *passwordData = [concatination sha256Data];
	NSString *password = [NSString base64StringFromData:passwordData];
	
	// Now replace + and / with ! and # to improve password compatibility
	password = [password stringByReplacingOccurrencesOfCharacter:'+' withCharacter:'!'];
	password = [password stringByReplacingOccurrencesOfCharacter:'/' withCharacter:'#'];
	password = [password substringToIndex:16];
	
	[_reveal setWord:password];
}

- (void)didGestureOnButton:(id)sender
{
	if ( [sender isKindOfClass:[UIGestureRecognizer class]] ) {
		switch ( [sender state] ) {
			case UIGestureRecognizerStateBegan:
				[self generateAndSetReveal:sender];
			case UIGestureRecognizerStateChanged:
				[_reveal setHidden:NO];
				[_generateButton setHidden:YES];
				break;
			case UIGestureRecognizerStateEnded:
			case UITouchPhaseCancelled:
				[_reveal setHidden:YES];
				[_generateButton setHidden:NO];
				break;
			default:
				break;
		}
		[_reveal didGesture:sender];
	}
}

- (IBAction)viewAbout:(id)sender
{
	PCDAboutViewController *about;
	about = [[PCDAboutViewController alloc] initWithNibName:@"PCDAboutViewController"
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

- (void)viewRestrictions:(id)sender
{
	PCDRestrictionsViewController *restrictions;
	restrictions = [[PCDRestrictionsViewController alloc] init];
//	[restrictions setDelegate:self];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:restrictions];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[_pagesView viewDidResize];
}

#pragma mark Walkthrough

- (void)startWalkthrough:(id)sender
{
	[sender dismissViewControllerAnimated:YES completion:nil];
	[_domainField resignFirstResponder];
	[_passwordField resignFirstResponder];
	
	[_pagesView setHidden:NO];
	[_pageControl setHidden:NO];
	
	isPresentingWalkthrough = YES;
}

- (void)endWalkthrough
{
	CFTimeInterval duration = 0.3f;
	
	CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[fadeOut setFromValue:@1.0f];
	[fadeOut setToValue:@0.0f];
	[fadeOut setDuration:duration];
	
	[[_pagesView layer] addAnimation:fadeOut forKey:@"alpha"];
	[_pagesView performSelector:@selector(setHidden:) withObject:@YES afterDelay:duration];
	[_pagesView setAlpha:1.0f];
	
	[[_pageControl layer] addAnimation:fadeOut forKey:@"alpha"];
	[_pageControl performSelector:@selector(setHidden:) withObject:@YES afterDelay:duration];
	[_pageControl setAlpha:1.0f];
	
	isPresentingWalkthrough = NO;
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
	
	// End walkthrough if previously presenting it
	if ( isPresentingWalkthrough ) {
		[self endWalkthrough];
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

#pragma mark Unload

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
