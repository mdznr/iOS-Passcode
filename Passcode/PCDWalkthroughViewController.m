//
//  PCDWalkthroughViewController.m
//  Passcode
//
//  Created by Matt on 12/29/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "PCDWalkthroughViewController.h"

@interface PCDWalkthroughViewController ()

@end

@implementation PCDWalkthroughViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"How To Use";
	
	// Create resizable card background image
	UIImage *cardBackground = [UIImage imageNamed:@"cardBackground"];
	cardBackground = [cardBackground resizableImageWithCapInsets:UIEdgeInsetsMake(12, 13, 14, 13)
													resizingMode:UIImageResizingModeStretch];
	CGRect cardRect = CGRectMake(17, 18, 286, 352);
	
	UIImageView *cb1 = [[UIImageView alloc] initWithImage:cardBackground];
	[cb1 setFrame:cardRect];
	[cb1 setCenter:CGPointMake(self.view.center.x, self.view.center.y-10)];
	[cb1 setAutoresizingMask:( UIViewAutoresizingFlexibleHeight |
							   UIViewAutoresizingFlexibleWidth )];
	[_page1 insertSubview:cb1 atIndex:0];
	
	UIImageView *cb2 = [[UIImageView alloc] initWithImage:cardBackground];
	[cb2 setFrame:cardRect];
	[cb2 setCenter:CGPointMake(self.view.center.x, self.view.center.y-10)];
	[cb2 setAutoresizingMask:( UIViewAutoresizingFlexibleHeight |
							   UIViewAutoresizingFlexibleWidth )];
	[_page2 insertSubview:cb2 atIndex:0];
	
	UIImageView *cb3 = [[UIImageView alloc] initWithImage:cardBackground];
	[cb3 setFrame:cardRect];
	[cb3 setCenter:CGPointMake(self.view.center.x, self.view.center.y-10)];
	[cb3 setAutoresizingMask:( UIViewAutoresizingFlexibleHeight |
							   UIViewAutoresizingFlexibleWidth )];
	[_page3 insertSubview:cb3 atIndex:0];
	
	UIImageView *cb4 = [[UIImageView alloc] initWithImage:cardBackground];
	[cb4 setFrame:cardRect];
	[cb4 setCenter:CGPointMake(self.view.center.x, self.view.center.y-10)];
	[cb4 setAutoresizingMask:( UIViewAutoresizingFlexibleHeight |
							   UIViewAutoresizingFlexibleWidth )];
	[_page4 insertSubview:cb4 atIndex:0];
	
	[_pagesView addPages:@[_page1, _page2, _page3, _page4]];
	
	[_pagesView setPageControl:_pageControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[self setPagesView:nil];
	[super viewDidUnload];
}

@end
