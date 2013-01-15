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
