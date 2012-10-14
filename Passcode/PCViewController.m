//
//  PCViewController.m
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCViewController.h"
#import <CommonCrypto/CommonDigest.h>

#define CC_SHA256_DIGEST_LENGTH	32	/* digest length in bytes */

@interface PCViewController ()

@end

@implementation PCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[_domainField becomeFirstResponder];
	
	[self checkSecuritySetting];
	
	// If running iOS 6.0 or higher, use smooth button resources, else glossy.
	BOOL smooth = NO;
	NSString *reqSysVer = @"6.0";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	if ([ currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending ) smooth = YES;
	
	// Set up Generate Button
	if (smooth) [_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonSmoothDisabled"] forState:UIControlStateDisabled];
	else [_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonDisabled"] forState:UIControlStateDisabled];
	[_generateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
	if (smooth) [_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f alpha:1.0f] forState:UIControlStateDisabled];
	else [_generateButton setTitleShadowColor:[UIColor colorWithWhite:.975f alpha:1.0f] forState:UIControlStateDisabled];
	[_generateButton titleLabel].shadowOffset = CGSizeMake(0, 1);			// Should only be for disabled state
	
	if (smooth) [_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonSmoothEnabled"] forState:UIControlStateNormal];
	else [_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonEnabled"] forState:UIControlStateNormal];
	[_generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	if (smooth) [_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
	else [_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:0.5f] forState:UIControlStateNormal];
	
	if (smooth) [_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonSmoothActive"] forState:UIControlStateHighlighted];
	else [_generateButton setBackgroundImage:[UIImage imageNamed:@"buttonActive"] forState:UIControlStateHighlighted];
	[_generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	if (smooth) [_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
	else [_generateButton setTitleShadowColor:[UIColor colorWithRed:42.0f/255.0f green:61.0f/255.0f blue:39.0f/255.0f alpha:0.5f] forState:UIControlStateHighlighted];
	
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
	if ( [[NSUserDefaults standardUserDefaults] boolForKey:@"save_password"]  )
	{
		_passwordField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
	}
	else
	{
		[[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"password"];
		_passwordField.text = @"";
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
	// Store the password in standardUserDefaults
	[[NSUserDefaults standardUserDefaults] setValue:[_passwordField text] forKey:@"password"];
	
	// Create the hash
	NSString *password = [self sha256HashFor:[[_domainField text] stringByAppendingString:[_passwordField text]]];
	
	// Copy it to pasteboard
	[[UIPasteboard generalPasteboard] setString:[password substringToIndex:16]];
	
	// Animation to show password has been copied
	[_copiedView display];
}

- (IBAction)viewAbout:(id)sender
{
	AboutViewController *about = [[AboutViewController alloc] init];
	[self presentModalViewController:about animated:YES];
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

- (void)viewDidUnload
{
	[self setPasswordField:nil];
	[self setGenerateButton:nil];
	[self setCopiedView:nil];
	[super viewDidUnload];
}
@end
