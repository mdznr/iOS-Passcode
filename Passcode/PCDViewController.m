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
#import "PCDPasscodeGenerator.h"
#import "PDKeychainBindings.h"
#import "MTZFarPanGestureRecognizer.h"
#import "NSURL+DomainName.h"

#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HEIGHT 44

@interface PCDViewController () {
}

@end

@implementation PCDViewController

#pragma mark Initialization and View Loading

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
	
	self.title = @"Passcode";
	
	// Set up the popover.
	_copiedWindow = [[MTZAppearWindow alloc] init];
	_copiedWindow.autoresizingMask = UIViewAutoresizingFlexibleMargins;
	_copiedWindow.image = [UIImage imageNamed:@"Copied"];
	_copiedWindow.text = @"Copied";
	
	// Load idiom-specific UI.
	switch ( [UIDevice currentDevice].userInterfaceIdiom ) {
		case UIUserInterfaceIdiomPad:
			[self loadViewForiPad];
			break;
		case UIUserInterfaceIdiomPhone:
			[self loadViewForiPhone];
			break;
	}
	
	// Add gesture recognizers on the generate button.
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	[_generateButton addGestureRecognizer:longPressGesture];
	
	MTZFarPanGestureRecognizer *panGesture = [[MTZFarPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	panGesture.minimumRequiredPanningDistance = 200.0f;
	[_generateButton addGestureRecognizer:panGesture];
	
	// Color the button.
	[_generateButton setTopColor:[UIColor colorWithRed: 52.0f/255.0f
												 green:196.0f/255.0f
												  blue:126.0f/255.0f
												 alpha:1.0f]
						forState:UIControlStateNormal];
	[_generateButton setBottomColor:[UIColor colorWithRed: 12.0f/255.0f
													green:150.0f/255.0f
													 blue: 86.0f/255.0f
													alpha:1.0f]
						forState:UIControlStateNormal];
	
	[_generateButton setTopColor:[UIColor colorWithRed: 45.0f/255.0f
												 green:171.0f/255.0f
												  blue:110.0f/255.0f
												 alpha:1.0f]
						forState:UIControlStateHighlighted];
	[_generateButton setBottomColor:[UIColor colorWithRed: 10.0f/255.0f
													green:125.0f/255.0f
													 blue: 71.0f/255.0f
													alpha:1.0f]
						   forState:UIControlStateHighlighted];
	
	[_generateButton setTopColor:[UIColor colorWithWhite:1.0f alpha:0.12f]
						forState:UIControlStateDisabled];
	[_generateButton setBottomColor:[UIColor colorWithWhite:1.0f alpha:0.05f]
						   forState:UIControlStateDisabled];
	
	_reveal.hidden = YES;
	
	[self checkSecuritySetting];
}

- (void)loadViewForiPhone
{
}

- (void)loadViewForiPad
{
	[self registerForKeyboardNotifications];
}


#pragma mark - View Controller Events

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// This is such a hack, but it was the only way to get it to work properly.
	[self performSelector:@selector(makeDomainFieldBecomeFirstResponder)
			   withObject:nil
			   afterDelay:DBL_MIN];
}

- (void)makeDomainFieldBecomeFirstResponder
{
	if ( !_domainField.isFirstResponder ) {
		[_domainField becomeFirstResponder];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// Display About if app hasn't been launched before.
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

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
 */


#pragma mark - Checks

- (void)checkPasteboard
{
	NSURL *url = [NSURL URLWithString:[[UIPasteboard generalPasteboard] string]];
	if ( !url ) {
		return;
	}
	
	NSString *domainName = [url domainName];
	if ( domainName ) {
		[self textDidChange:self];
		_domainField.text = domainName;
	}
}

- (void)checkSecuritySetting
{
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == YES ) {
		if ( [bindings objectForKey:@"passwordString"] ) {
			_passwordField.text = [bindings objectForKey:@"passwordString"];
		}
	} else if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == NO ) {
		[bindings setObject:@"" forKey:@"passwordString"];
		_passwordField.text = @"";
	}
}


#pragma mark - Generate Button

- (IBAction)generateAndCopy:(id)sender
{
	// Store the password in keychain
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	[bindings setObject:[_passwordField text] forKey:@"passwordString"];
	
	NSString *password = [[PCDPasscodeGenerator sharedInstance] passcodeForDomain:_domainField.text
																andMasterPassword:_passwordField.text];
	
	// Copy it to pasteboard
	[[UIPasteboard generalPasteboard] setString:password];
	
	// Center the appear window to the container.
	UIView *centeringView = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? _verticalCenteringView : _container;
	_copiedWindow.center = centeringView.center;
	
	// Animation to show password has been copied
	[_copiedWindow display];
}

- (void)generateAndSetReveal:(id)sender
{
	NSString *password = [[PCDPasscodeGenerator sharedInstance] passcodeForDomain:_domainField.text
																andMasterPassword:_passwordField.text];
	
	_reveal.hiddenWord = password;
}

- (void)didGestureOnButton:(UIGestureRecognizer *)sender
{
	switch ( sender.state ) {
		case UIGestureRecognizerStateBegan:
			[self generateAndSetReveal:sender];
			_reveal.hidden = NO;
			_generateButton.hidden = YES;
		case UIGestureRecognizerStateChanged:
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			_reveal.hidden = YES;
			_generateButton.hidden = NO;
			break;
		default:
			break;
	}
	[_reveal didGesture:sender];
}


#pragma mark - Navigation

- (IBAction)viewAbout:(id)sender
{
	PCDAboutViewController *about;
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PCDAboutViewController" bundle:nil];
	about = [sb instantiateViewControllerWithIdentifier:@"PCDAboutViewController"];
	
	[self viewModalViewController:about];
}

- (IBAction)viewRestrictions:(id)sender
{
	PCDRestrictionsViewController *requirements = [[PCDRestrictionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
	
	[self viewModalViewController:requirements];
}

- (void)viewModalViewController:(UIViewController *)vc
{
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
	[navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
	[self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Text Field Delegate Methods

- (IBAction)textDidChange:(id)sender
{
	if ( _domainField.text.length > 0 && _passwordField.text.length > 0 ) {
		_generateButton.enabled = YES;
	} else {
		_generateButton.enabled = NO;
	}
}

- (BOOL)textFieldDidBeginEditing:(UITextField *)textField
{
	if ( _passwordField.text.length > 0 ) {
		_domainField.returnKeyType = UIReturnKeyGo;
	} else {
		_domainField.returnKeyType = UIReturnKeyNext;
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ( _domainField.text.length > 0 && _passwordField.text.length > 0 ) {
		[self generateAndCopy:nil];
		return NO;
	} else if ( _passwordField.text.length > 0 ) {
		return NO;
	}
	
	[_passwordField becomeFirstResponder];
	
	return YES;
}


#pragma mark - Handle Keyboard Notifications

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

#pragma mark - Unload

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[self setPasswordField:nil];
	[self setGenerateButton:nil];
	[self setCopiedWindow:nil];
	[self setContainer:nil];
	[self setView:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}

@end
