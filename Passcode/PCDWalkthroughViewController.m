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
	[_scrollView setContentSize:CGSizeMake(320*4, 416)];
	[_scrollView addSubview:_page1];
	[_scrollView addSubview:_page2];
	[_page2 setFrame:CGRectMake(320*1, 0, 320, 416)];
	[_scrollView addSubview:_page3];
	[_page3 setFrame:CGRectMake(320*2, 0, 320, 416)];
	[_scrollView addSubview:_page4];
	[_page4 setFrame:CGRectMake(320*3, 0, 320, 416)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[self setScrollView:nil];
	[super viewDidUnload];
}

@end
