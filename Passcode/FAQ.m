//
//  FAQ.m
//  Passcode
//
//  Created by Matt on 10/12/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "FAQ.h"

@interface FAQ ()

@end

@implementation FAQ

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[_scrollView setContentSize:CGSizeMake(280, _faqText.frame.size.height+40)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setScrollView:nil];
	[self setFaqText:nil];
	[super viewDidUnload];
}
- (IBAction)done:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
