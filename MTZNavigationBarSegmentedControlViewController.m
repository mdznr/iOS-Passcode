//
//  MTZNavigationBarSegmentedControlViewController.m
//
//  Created by Matt on 5/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZNavigationBarSegmentedControlViewController.h"
#import "UISegmentedControl+setItems.h"

@interface MTZNavigationBarSegmentedControlViewController ()

@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation MTZNavigationBarSegmentedControlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
	self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	[self.navigationBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self.view addSubview:self.navigationBar];
	
	// Make items dynamic
	_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[]];
	[_segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
	[_segmentedControl setSelectedSegmentIndex:0]; // This should be default
	[_segmentedControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
	UINavigationItem *navItem = [[UINavigationItem alloc] init];
	[navItem setTitleView:_segmentedControl];
	[self.navigationBar setItems:@[navItem]];
}

- (void)segmentedControlDidChange:(UISegmentedControl *)sender
{
	[self setSelectedIndex:sender.selectedSegmentIndex];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
	_viewControllers = viewControllers;
	NSMutableArray *titles = [[NSMutableArray alloc] initWithCapacity:_viewControllers.count];
	for ( UIViewController *vc in viewControllers ) {
		// Get titles of View Controllers
		NSString *title = vc.title;
		if ( title ) {
			[titles addObject:vc.title];
		} else {
			[titles addObject:@""];
		}
	}
	[_segmentedControl setItems:titles];
}

- (NSInteger)selectedIndex
{
	return _segmentedControl.selectedSegmentIndex;
}

- (void)setSelectedIndex:(NSInteger)index
{
	NSLog(@"%@", _viewControllers);
	if ( self.childViewControllers.count ) {
		[self.childViewControllers[0] removeFromParentViewController];
	}
	UIViewController *vc = _viewControllers[index];
	[self addChildViewController:vc];
	
	// Set Navigation Item on each View Controller
	UINavigationItem *item = self.navigationBar.items[0];
	[item setLeftBarButtonItems:vc.navigationItem.leftBarButtonItems animated:NO];
	[item setRightBarButtonItems:vc.navigationItem.rightBarButtonItems animated:NO];
	
	[_segmentedControl setSelectedSegmentIndex:index];
}

- (void)addChildViewController:(UIViewController *)childController
{
	[super addChildViewController:childController];
	UIView *childView = childController.view;
	CGFloat yOffset = _navigationBar.frame.origin.y + _navigationBar.frame.size.height;
	CGRect rect = (CGRect){self.view.bounds.origin.x, yOffset, self.view.bounds.size.width, self.view.bounds.size.height - yOffset};
	[childView setFrame:rect];
	[self.view setAutoresizesSubviews:YES];
	[self.view insertSubview:childController.view belowSubview:_navigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
