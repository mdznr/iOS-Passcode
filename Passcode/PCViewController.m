//
//  PCViewController.m
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "PDKeychainBindings.h"

#define CC_SHA256_DIGEST_LENGTH	32	/* digest length in bytes */

@interface PCViewController ()

@end

@implementation PCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self registerForKeyboardNotifications];
	[_domainField becomeFirstResponder];
	[self checkSecuritySetting];
	
	// If running iOS 6.0 or higher, use smooth button resources, else glossy.
	BOOL smooth = NO;
	NSString *reqSysVer = @"6.0";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	if ([ currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending ) smooth = YES;
	
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
	{
		// Set up Generate Button
		if (smooth)
		{
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonDisabled"] forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f alpha:1.0f] forState:UIControlStateDisabled];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonEnabledGreen"] forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonActiveGreen"] forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
		}
		else
		{
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonDisabledGlossy"] forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f alpha:1.0f] forState:UIControlStateDisabled];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonEnabledGreenGlossy"] forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:0.5f] forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonActiveGreenGlossy"] forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:0.5f] forState:UIControlStateHighlighted];
		}
		
		[_generateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
		[_generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0, 1);			// Should only be for disabled state
	}
	else
	{
		// Set up Generate Button
		if (smooth)
		{
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonEnabledGreen"] forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonActiveGreen"] forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonDisabled"] forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f alpha:1.0f] forState:UIControlStateDisabled];
		}
		else
		{
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonEnabledGreenGlossy"] forState:UIControlStateNormal];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:0.5f] forState:UIControlStateNormal];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonActiveGreenGlossy"] forState:UIControlStateHighlighted];
			[_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:0.5f] forState:UIControlStateHighlighted];
			
			[_generateButton setBackgroundImage:[UIImage imageNamed:@"iPadButtonDisabled"] forState:UIControlStateDisabled];
			[_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f alpha:1.0f] forState:UIControlStateDisabled];
		}
		
		[_generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[_generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[_generateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0,1);	// Should only be for disabled state
		
		[self registerForKeyboardNotifications];
	}
	
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	
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
		[self textDidChange:nil];
	}
}

- (void)checkSecuritySetting
{
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	
	// If the save_password has yet to be set (Should be YES by default, but isn't working?)
	if ( (void *) [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == nil )
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"save_password"];
	
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"] == YES )
	{
		if ( [bindings objectForKey:@"passwordString"] )
			[_passwordField setText:[bindings objectForKey:@"passwordString"]];
	}
	else
	{
		[bindings setObject:[_passwordField text] forKey:@"passwordString"];
		[_passwordField setText:@""];
	}
}

-(NSString*)sha256HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
	
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (IBAction)generateAndCopy:(id)sender
{
	// Store the password in keychain
	PDKeychainBindings *bindings = [PDKeychainBindings sharedKeychainBindings];
	[bindings setObject:[_passwordField text] forKey:@"passwordString"];
	
	// Create the hash
	NSString *password = [self sha256HashFor:[[_domainField text] stringByAppendingString:[_passwordField text]]];
	
	// Copy it to pasteboard
	[[UIPasteboard generalPasteboard] setString:[password substringToIndex:16]];
	
	// Animation to show password has been copied
	[_copiedView display];
}

- (IBAction)viewAbout:(id)sender
{
	AboutViewController *about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
//	about.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
#warning crash on iOS 5
	[self presentViewController:about animated:YES completion:nil];
}

- (IBAction)textDidChange:(id)sender
{
	if ( (int) [[_domainField text] length] && (int) [[_passwordField text] length] )
	{
		[_generateButton setEnabled:YES];
		[_generateButton titleLabel].shadowOffset = CGSizeMake(0, -1);
	}
	else
	{
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
	if ( (int) [[_domainField text] length] && (int) [[_passwordField text] length] )
	{
		[self generateAndCopy:nil];
		return NO;
	}
	else if ( (int) [[_passwordField text] length] )
	{
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

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWasShown:)
												 name:UIKeyboardWillChangeFrameNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillBeHidden:)
												 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
	/*
	NSDictionary* info = [aNotification userInfo];
	_kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	
	NSLog(@"keyboardWasShown");
	
	[_container setFrame:CGRectMake( (self.view.frame.size.width - _container.frame.size.width )/2 + self.view.frame.origin.x,
									 (self.view.superview.frame.size.height - _kbSize.height - _container.frame.size.height )/2 + self.view.frame.origin.y,
									_container.frame.size.width,
									_container.frame.size.height)];
	 */
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{	
	[self adjustToInterfaceOrientation:toInterfaceOrientation];
}

- (void)adjustToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	CGFloat width = _container.frame.size.width;
	CGFloat height = _container.frame.size.height;
	
	if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
	{
		[_container setFrame:CGRectMake(floorl((768 - width )/2),
										floorl((1024 - 44 - 264 - height )/2) + 44,
										width,
										height)];
	}
	else
	{
		[_container setFrame:CGRectMake(floorl((1024 - width )/2),
										floorl((768 - 44 - 352 - height )/2) + 44,
										width,
										height)];
	}
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	
}

- (void)viewDidUnload
{
	[self setPasswordField:nil];
	[self setGenerateButton:nil];
	[self setCopiedView:nil];
	[self setContainer:nil];
	[self setNavigationBar:nil];
	[self setView:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}
@end
