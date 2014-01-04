//
//  PCDRestrictionsViewController.m
//  Passcode
//
//  Created by Matt Zanchelli on 1/2/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "PCDRestrictionsViewController.h"

@interface PCDRestrictionsViewController ()

@property (nonatomic) BOOL automatic;

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
	
#warning TODO: Look for record of domain
	
	// Automatic is default
	_automatic = YES;
	
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

- (void)automaticSwitchChanged:(UISwitch *)sender
{
	// No changes made
	if ( _automatic == sender.on ) return;
	
	_automatic = sender.on;
	
	NSMutableIndexSet *deleteIndexes = [[NSMutableIndexSet alloc] init];
	NSMutableIndexSet *insertIndexes = [[NSMutableIndexSet alloc] init];
	
	if ( _automatic ) {
		// Moving to automatic mode
		[deleteIndexes addIndex:1]; // Hide Length Slider
		[deleteIndexes addIndex:2]; // Hide Character Restrictions
		
		[insertIndexes addIndex:1]; // Show Definitions Selector
	} else {
		// Moving to manual mode
		[deleteIndexes addIndex:1]; // Hide Definitions Selector
		
		[insertIndexes addIndex:1]; // Show Length Slider
		[insertIndexes addIndex:2]; // Show Character Restrictions
	}
	
	[self.tableView beginUpdates];
	
	[self.tableView deleteSections:deleteIndexes
				  withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView insertSections:insertIndexes
				  withRowAnimation:UITableViewRowAnimationFade];
	
	[self.tableView endUpdates];
}

- (void)lengthSliderChanged:(UISlider *)sender
{
#warning handle length slider changed back-end
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{	
	if ( _automatic ) {
		return 2;
	} else {
		return 3;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ( _automatic ) {
		switch ( section ) {
			case 0: return 1; // Automatic Switch
			case 1: return 1; // Definitions Selector
			default: return 0;
		}
	} else {
		switch ( section ) {
			case 0: return 1; // Automatic Switch
			case 1: return 1; // Length
			case 2: return 4; // Character Restrictions
			default: return 0;
		}
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if ( _automatic ) {
		return @"";
	} else {
		switch ( section ) {
			case 0: return @"";
			case 1: return @"Length";
			case 2: return @"Character Restrictions";
			default: return @"";
		}
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	if ( _automatic ) {
		switch ( section ) {
			case 0: return @"Automatically meet password requirements of the domain.";
			case 1: return @"Using latest requirements for [domain]\nLast updated on [date]";
			default: return @"";
		}
	} else {
		switch ( section ) {
			case 0: return @"Automatically meet password requirements of the domain.";
			case 1: return @"";
			case 2: return @"";
			default: return @"";
		}
	}
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	
}
 */

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	
}
 */

- (UITableViewCell *)automaticSwitch
{
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.textLabel.text = NSLocalizedString(@"Automatic", nil);
	
	UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	cell.accessoryView = mySwitch;
	
	[mySwitch addTarget:self
				 action:@selector(automaticSwitchChanged:)
	   forControlEvents:UIControlEventValueChanged];
	
	mySwitch.on = _automatic;
	
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ( _automatic ) {
		if ( indexPath.section == 0 && indexPath.row == 0 ) {
			// Automatic Switch
			return [self automaticSwitch];
		} else if ( indexPath.section == 1 && indexPath.row == 0 ) {
			// Definitions Selector
			UITableViewCell *cell = [[UITableViewCell alloc] init];
			cell.textLabel.text = NSLocalizedString(@"Available Definitions", nil);
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return cell;
		}
	} else {
		if ( indexPath.section == 0 && indexPath.row == 0 ) {
			// Automatic Switch
			return [self automaticSwitch];
		} else if ( indexPath.section == 1 && indexPath.row == 0 ) {
			// Length Slider
			UITableViewCell *cell = [[UITableViewCell alloc] init];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			// Min. Length
			UILabel *minLength = [[UILabel alloc] initWithFrame:(CGRect){15, 0, 24, cell.contentView.frame.size.height}];
			minLength.textAlignment = NSTextAlignmentLeft;
			minLength.textColor = [UIColor darkGrayColor];
			minLength.text = [NSString stringWithFormat:@"%d", 12];
			[cell.contentView addSubview:minLength];

			// Max. Length
			UILabel *maxLength = [[UILabel alloc] initWithFrame:(CGRect){cell.contentView.frame.size.width - 15 - 24, 0, 24, cell.contentView.frame.size.height}];
			maxLength.textAlignment = NSTextAlignmentRight;
			maxLength.textColor = [UIColor darkGrayColor];
			maxLength.text = [NSString stringWithFormat:@"%d", 24];
			[cell.contentView addSubview:maxLength];
			
			// Slider
			UISlider *lengthSlider = [[UISlider alloc] initWithFrame:(CGRect){15 + 24 + 4, 0, cell.contentView.frame.size.width - (2 * (15 + 24 + 4)), 44}];
			[lengthSlider addTarget:self action:@selector(lengthSliderChanged:) forControlEvents:UIControlEventValueChanged];
			lengthSlider.continuous = YES;
			lengthSlider.minimumValue = 12;
			lengthSlider.maximumValue = 24;
			lengthSlider.value = 16;
			[cell addSubview:lengthSlider];
			
			return cell;
		} else if ( indexPath.section == 2 ) {
			// Character Restrictions
			UITableViewCell *cell = [[UITableViewCell alloc] init];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			switch ( indexPath.row ) {
				case 0: cell.textLabel.text = @"Symbols"; break;
				case 1: cell.textLabel.text = @"Numbers"; break;
				case 2: cell.textLabel.text = @"Uppercase"; break;
				case 3: cell.textLabel.text = @"Lowercase"; break;
				default: break;
			}
			return cell;
		}
	}
	
	return nil;
}

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
