//
//  PCDRestrictionsViewController.m
//  Passcode
//
//  Created by Matt Zanchelli on 1/2/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "PCDRestrictionsViewController.h"

@interface PCDRestrictionsViewController ()

@end

@implementation PCDRestrictionsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	
	// Listen to UIContentSizeCategoryDidChangeNotification (Dynamic Type)
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(preferredContentSizeDidChange:)
												 name:UIContentSizeCategoryDidChangeNotification
											   object:nil];
	
	self.title = NSLocalizedString(@"Requirements", nil);
    
    // Done button to dismiss view controller
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
															 style:UIBarButtonItemStyleDone
															target:self
															action:@selector(done:)];
	self.navigationItem.leftBarButtonItem = done;
	
#warning remove right bar button item after time/other touch activity
	// Invisible right bar button to also dismiss view controller
	// Only use on iPhone/iPod touch:
	if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		UIButton *invisible = [UIButton buttonWithType:UIButtonTypeCustom];
		[invisible setTitle:@"        " forState:UIControlStateNormal];
		// Would be nice not having to hard-code in width and height
		invisible.frame = CGRectMake(0, 0, 55, 32);
		invisible.showsTouchWhenHighlighted = YES;
		UIBarButtonItem *secretlyDone = [[UIBarButtonItem alloc] initWithCustomView:invisible];
		[invisible addTarget:self
					  action:@selector(done:)
			forControlEvents:UIControlEventTouchUpInside];
		self.navigationItem.rightBarButtonItem = secretlyDone;
	}
}

- (void)preferredContentSizeDidChange:(id)sender
{
	[self.tableView reloadData];
}

- (void)done:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
 */

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma UIViewController Misc.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
