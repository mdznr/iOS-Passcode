//
//  MTZNavigationBarSegmentedControlViewController.h
//
//  Created by Matt on 5/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZNavigationBarSegmentedControlViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;

- (NSInteger)selectedIndex;
- (void)setSelectedIndex:(NSInteger)index;

@end
