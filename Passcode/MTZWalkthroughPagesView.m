//
//  MTZWalkthroughPagesView.m
//  Passcode
//
//  Created by Matt on 1/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZWalkthroughPagesView.h"

@implementation MTZWalkthroughPagesView
{
	NSMutableArray *allPages;
	int currentPageIndex;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if ( self ) {
		// Initialization code
		[self setup];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
		// Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
	[self setDelegate:self];
	
	[self setPagingEnabled:YES];
	[self setScrollsToTop:NO];
	[self setShowsHorizontalScrollIndicator:NO];
	[self setShowsVerticalScrollIndicator:NO];
	
	// Most walkthroughs should have at least three items.
	allPages = [[NSMutableArray alloc] initWithCapacity:3];
	
	// Start off the walkthrough on the first page
	currentPageIndex = 0;
}

- (void)setPageControl:(UIPageControl *)pageControl
{
	_pageControl = pageControl;
	[_pageControl setNumberOfPages:allPages.count];
	[_pageControl setCurrentPage:currentPageIndex];
}

- (void)addPage:(UIView *)page
{
	[self addSubview:page];
	[allPages addObject:page];
	[self updateSizingAndPositioning];
}

- (void)addPage:(UIView *)page atIndex:(int)index
{
	[self addSubview:page];
	[allPages insertObject:page atIndex:index];
	[self updateSizingAndPositioning];
}

- (void)addPages:(NSArray *)pages
{
	for ( NSInteger i=0; i < pages.count; ++i ) {
		[self addSubview:pages[i]];
	}
	[allPages addObjectsFromArray:pages];
	[self updateSizingAndPositioning];
}

- (void)updateSizingAndPositioning
{
	NSInteger numberOfPages = allPages.count;
	for ( NSInteger i=0; i < numberOfPages; ++i ) {
		[allPages[i] setFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
	}
	[self setContentSize:CGSizeMake(self.frame.size.width * numberOfPages, self.frame.size.height)];
	[_pageControl setNumberOfPages:numberOfPages];
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	currentPageIndex = (int) ( ( scrollView.contentOffset.x / scrollView.frame.size.width ) + .5 );
	[_pageControl setCurrentPage:currentPageIndex];
}

@end
