//
//  PCDWalkthroughViewController.h
//  Passcode
//
//  Created by Matt on 12/29/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MTZWalkthroughPagesView.h"

@interface PCDWalkthroughViewController : UIViewController

@property (strong, nonatomic) IBOutlet MTZWalkthroughPagesView *pagesView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *page1, *page2, *page3, *page4;

@end
