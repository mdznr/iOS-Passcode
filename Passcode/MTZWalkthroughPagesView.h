//
//  MTZWalkthroughPagesView.h
//  Passcode
//
//  Created by Matt on 1/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZWalkthroughPagesView : UIScrollView

@property (strong, nonatomic) UIPageControl *pageControl;

- (void)addPage:(UIView *)view;
- (void)addPage:(UIView *)view atIndex:(int)index;
- (void)addPages:(NSArray *)pages;

@end
