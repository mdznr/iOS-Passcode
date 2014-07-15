//
//  PCDViewController.m
//  Passcode
//
//  Created by Matt Zanchelli on 8/7/12.
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

#import "PCDAboutViewController.h"
#import "PCDRestrictionsViewController.h"

#import "NSURL+DomainName.h"

#import "PCDUnifiedGeneratorViewController.h"

#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HEIGHT 44

@interface PCDViewController ()

@property (nonatomic, strong) IBOutlet UIView *view;
@property (nonatomic, weak)   IBOutlet UIView *verticalCenteringView;
@property (nonatomic, strong) IBOutlet UIView *container;

@end

@implementation PCDViewController

#pragma mark - Initialization and View Loading

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
	
	// Load idiom-specific UI.
	switch ([UIDevice currentDevice].userInterfaceIdiom) {
		case UIUserInterfaceIdiomPad: {
			[self loadViewForiPad];
		} break;
		case UIUserInterfaceIdiomPhone: {
			[self loadViewForiPhone];
		} break;
		default:
			break;
	}
	
	UIViewController<PCDPasscodeGeneratorViewControllerProtocol> *generatorViewController = [[PCDUnifiedGeneratorViewController alloc] initWithNibName:@"PCDUnifiedGeneratorViewController" bundle:nil];
	self.generatorViewController = generatorViewController;
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
			   afterDelay:0];
}

- (void)makeDomainFieldBecomeFirstResponder
{
//	if ( !_serviceNameField.textField.isFirstResponder ) {
//		[_serviceNameField.textField becomeFirstResponder];
//	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// Display About if app hasn't been launched before.
	if ( ![[NSUserDefaults standardUserDefaults] boolForKey:kPCDHasLaunchedApp] ) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kPCDHasLaunchedApp];
		[self viewAbout:self];
	}
}

- (NSUInteger)supportedInterfaceOrientations
{
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) {
		return UIInterfaceOrientationMaskPortrait;
    } else {
		return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	if ( [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ) {
		return toInterfaceOrientation == UIInterfaceOrientationPortrait;
    } else {
		return YES;
    }
}

- (void)viewControllerDidBecomeActive
{
	[self checkPasteboard];
	//	[_serviceNameField.textField becomeFirstResponder];
	//	if ( _serviceNameField.textField.text.length > 0 ) {
	//		[_serviceNameField.textField selectAll:self];
	//	}
}


#pragma mark - Public API

- (void)setGeneratorViewController:(UIViewController<PCDPasscodeGeneratorViewControllerProtocol> *)generatorViewController
{
	[_generatorViewController removeFromParentViewController];
	
	_generatorViewController = generatorViewController;
	[self addChildViewController:_generatorViewController];
}


#pragma mark - Child View Controller

- (void)addChildViewController:(UIViewController *)childController
{
	[super addChildViewController:childController];
	
	childController.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	
	[self.verticalCenteringView addSubview:childController.view];
}


#pragma mark - Checks

- (void)checkPasteboard
{
	NSURL *url = [NSURL URLWithString:[[UIPasteboard generalPasteboard] string]];
	if (!url) {
		return;
	}
	
	NSString *domainName = [url domainName];
	if (domainName) {
		[self.generatorViewController setServiceName:domainName];
	}
}

- (void)checkSecuritySetting
{
	// If preference says to save password, authenticate.
	if ([[NSUserDefaults standardUserDefaults] boolForKey:kPCDSavePassword] == YES) {
		[self authenticateWithLocalAuthentication];
	}
	// Otherwise, clear any saved password.
	else {
		[self.generatorViewController setServiceName:@""];
		[self updateSavedPassword];
	}
}

/// Try to authenticate with local authentication, otherwise authenticate normally.
- (void)authenticateWithLocalAuthentication
{
//	if ([LAContext class]) {
//		LAContext *myContext = [[LAContext alloc] init];
//		NSError *authError = nil;
//		if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
//			[myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
//					  localizedReason:NSLocalizedString(@"Unlock Master Password", nil)
//								reply:^(BOOL success, NSError *error) {
//									if (success) {
//										// User authenticated successfully, take appropriate action.
//										[self authenticate];
//									} else {
//										// User did not authenticate successfully, look at error and take appropriate action.
//									}
//								}];
//		} else {
//			// Could not evaluate policy; look at authError and present an appropriate message to user
//			[self authenticate];
//		}
//	} else {
//		[self authenticate];
//	}
}

/// Authenticate normally.
- (void)authenticate
{
//	NSString *passwordString = [SSKeychain passwordForService:kPCDServiceName account:kPCDAccountName];
//	if (passwordString) {
//		// Update the UI.
//		dispatch_async(dispatch_get_main_queue(), ^{
//			_secretCodeField.textField.text = passwordString;
//			[self textDidChange:_secretCodeField];
//		});
//	}
}

/// Update the saved password using the current password in the secret code field.
- (void)updateSavedPassword
{
//	[SSKeychain setPassword:_secretCodeField.textField.text
//				 forService:kPCDServiceName
//					account:kPCDAccountName];
}


#pragma mark - Navigation

- (IBAction)viewAbout:(id)sender
{
	PCDAboutViewController *about;
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PCDAboutViewController" bundle:nil];
	about = [sb instantiateViewControllerWithIdentifier:@"PCDAboutViewController"];
	
	[self viewModalViewController:about];
}

- (IBAction)viewSettings:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
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


#pragma mark - Handle Keyboard Notifications

- (void)keyboardChanged:(id)object
{
	// Based on implentation in Genesis.
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


#pragma mark - Dealloc

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
