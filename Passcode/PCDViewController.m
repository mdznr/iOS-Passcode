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
	
	// Add insets to the text fields
//	UIEdgeInsets textFieldInsets = (UIEdgeInsets) {0, 10, 0, 10};
	UIEdgeInsets textFieldInsets = UIEdgeInsetsZero;
	_domainField.contentInset = textFieldInsets;
	_passwordField.contentInset = textFieldInsets;
	
	// Set up popover
	_copiedWindow = [[MTZAppearWindow alloc] init];
	_copiedWindow.autoresizingMask =  UIViewAutoresizingFlexibleTopMargin
									| UIViewAutoresizingFlexibleBottomMargin
									| UIViewAutoresizingFlexibleLeftMargin
									| UIViewAutoresizingFlexibleRightMargin;
	_copiedWindow.imageName = @"copied";
	_copiedWindow.text = @"Copied";
	
	[self checkSecuritySetting];
	
	// Load idiom-specific UI
	switch ( [UIDevice currentDevice].userInterfaceIdiom ) {
		case UIUserInterfaceIdiomPad:
			[self loadViewForiPad];
			break;
		case UIUserInterfaceIdiomPhone:
			[self loadViewForiPhone];
			break;
		default:
			break;
	}
	
	_copiedWindow.center = (CGPoint){_container.center.x, _container.center.y + STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT};
	
	UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	[_generateButton addGestureRecognizer:longPressGesture];
	
	MTZFarPanGestureRecognizer *panGesture = [[MTZFarPanGestureRecognizer alloc] initWithTarget:self action:@selector(didGestureOnButton:)];
	[panGesture setMinimumRequiredPanningDistance:200.0f];
	[_generateButton addGestureRecognizer:panGesture];
	
	[_reveal setHidden:YES];
}

- (void)loadViewForiPhone
{
	_copiedWindow.frame = (CGRect){0, 0, 128, 128};
}

- (void)loadViewForiPad
{
	_copiedWindow.frame = (CGRect){0, 0, 192, 192};
	
	[self registerForKeyboardNotifications];
}


#pragma mark View Events

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// This is such a hack, but it was the only way to get it to work properly
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
}


#pragma mark Checks

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


#pragma mark Generate Button

- (IBAction)generateAndCopy:(id)sender
{
	// Store the password in keychain
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	[bindings setObject:[_passwordField text] forKey:@"passwordString"];
	
	NSString *password = [[PCDPasscodeGenerator sharedInstance] passcodeForDomain:_domainField.text
																andMasterPassword:_passwordField.text];
	
	// Copy it to pasteboard
	[[UIPasteboard generalPasteboard] setString:password];
	
	// Animation to show password has been copied
	[_copiedWindow display];
}

- (void)generateAndSetReveal:(id)sender
{
	NSString *password = [[PCDPasscodeGenerator sharedInstance] passcodeForDomain:_domainField.text
																andMasterPassword:_passwordField.text];
	
	[_reveal setWord:password];
}

- (void)didGestureOnButton:(id)sender
{
	if ( [sender isKindOfClass:[UIGestureRecognizer class]] ) {
		switch ( ((UIGestureRecognizer *) sender).state ) {
			case UIGestureRecognizerStateBegan:
				[self generateAndSetReveal:sender];
				[_reveal setHidden:NO];
				[_generateButton setHidden:YES];
			case UIGestureRecognizerStateChanged:
				break;
			case UIGestureRecognizerStateEnded:
			case UIGestureRecognizerStateCancelled:
				[_reveal setHidden:YES];
				[_generateButton setHidden:NO];
				break;
			default:
				break;
		}
		[_reveal didGesture:sender];
	}
}


#pragma mark Navigation

- (IBAction)viewAbout:(id)sender
{
	PCDAboutViewController *about;
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PCDAboutViewController" bundle:nil];
	about = [sb instantiateViewControllerWithIdentifier:@"PCDAboutViewController"];
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:about];
	[navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
	[self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)viewRestrictions:(id)sender
{
	PCDRestrictionsViewController *restrictions;
	restrictions = [[PCDRestrictionsViewController alloc] init];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:restrictions];
	[navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
	[self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark Text Field Delegate Methods

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
	[self setCopiedWindow:nil];
	[self setContainer:nil];
	[self setView:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}

@end
