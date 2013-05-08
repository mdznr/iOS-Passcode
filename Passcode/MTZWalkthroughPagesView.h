//
//  MTZWalkthroughPagesView.h
//  Passcode
//
//  Created by Matt on 1/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZWalkthroughPagesView : UIScrollView<UIScrollViewDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;

- (id)initWithPages:(NSArray *)pages;

- (void)addPage:(UIView *)view;
- (void)addPage:(UIView *)view atIndex:(int)index;
- (void)addPages:(NSArray *)pages;

- (void)scrollToPageIndex:(int)index;
- (void)scrollToPreviousPage;
- (void)scrollToNextPage;

- (void)viewDidResize;

@end
