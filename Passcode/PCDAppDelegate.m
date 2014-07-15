//
//  PCDAppDelegate.m
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCDAppDelegate.h"
#import "UIViewController+Active.m"

#if RUN_KIF_TESTS
#import "EXTestController.h"
#endif

static NSString *kURLSchemePrefix = @"passcode://";

@implementation PCDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Register the preference defaults early.
    NSDictionary *appDefaults = @{kPCDSavePassword: @YES, kPCDHasLaunchedApp: @NO};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	PCDViewController *mainViewController;
	
	if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
		mainViewController = [[PCDViewController alloc] initWithNibName:@"PCDViewController" bundle:nil];
	} else {
		mainViewController = [[PCDViewController alloc] initWithNibName:@"PCDViewController_iPad" bundle:nil];
	}
	
	self.mainViewController = mainViewController;
	self.window.rootViewController = self.mainViewController;
	self.window.tintColor = [PCDAppDelegate appKeyColor];
    [self.window makeKeyAndVisible];
	
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
	NSString *urlString = url.absoluteString;
	if ( [urlString hasPrefix:kURLSchemePrefix] ) {
		urlString = [urlString substringFromIndex:kURLSchemePrefix.length];
		[self.mainViewController.generatorViewController setServiceName:urlString];
		//	Automatically copy to clipboard and return to Safari?
		//	Perhaps this can be done in Safari javascript anyways?
		return YES;
	} else {
		return NO;
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	
	[self.mainViewController viewControllerDidBecomeActive];
}

+ (UIColor *)appKeyColor
{
	return [UIColor colorWithHue:151.0f/360.0f
					  saturation:0.79f
					  brightness:0.7f
						   alpha:1.0f];
}

@end
