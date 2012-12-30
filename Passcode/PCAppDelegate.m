//
//  PCAppDelegate.m
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCAppDelegate.h"
#import "PCViewController.h"

#if RUN_KIF_TESTS
#import "EXTestController.h"
#endif

@implementation PCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Register the preference defaults early.
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithBool:YES],
																	  [NSNumber numberWithBool:NO]]
															forKeys:@[@"save_password",
								 									  @"hasLaunchedAppBefore"]];
	
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
	PCViewController *mainViewController;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    mainViewController = [[PCViewController alloc] initWithNibName:@"PCViewController" bundle:nil];
	} else {
	    mainViewController = [[PCViewController alloc] initWithNibName:@"PCViewController_iPad" bundle:nil];
	}
	
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
	
	// Display About if app hasn't been launched before
	if ( ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedAppBefore"] )
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedAppBefore"];
		AboutViewController* about = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
		[self.viewController presentModalViewController:about animated:YES];
	}
	
#if RUN_KIF_TESTS
    [[EXTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
        exit([[EXTestController sharedInstance] failureCount]);
    }];
#endif
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	UITextField* domainField = _viewController.domainField;
	
	[_viewController checkPasteboard];
	[_viewController checkSecuritySetting];
	[domainField becomeFirstResponder];
	
	// Select domainField text
	UITextPosition *beginning = domainField.beginningOfDocument;
    UITextPosition *start = [domainField positionFromPosition:beginning offset:0];
	UITextPosition *end = [domainField positionFromPosition:start offset:domainField.text.length];
    UITextRange *textRange = [domainField textRangeFromPosition:start toPosition:end];
	[domainField setSelectedTextRange:textRange];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
