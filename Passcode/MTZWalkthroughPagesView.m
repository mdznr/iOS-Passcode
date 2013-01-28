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
	NSMutableArray *selectorsForPages;
	NSMutableArray *objectsForPages;
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

- (id)initWithPages:(NSArray *)pages
{
	self = [super init];
	if ( self ) {
		[self setup];
		[self addPages:pages];
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
	
	selectorsForPages = [[NSMutableArray alloc] initWithCapacity:3];
	objectsForPages = [[NSMutableArray alloc] initWithCapacity:3];
	
	// Start off the walkthrough on the first page
	currentPageIndex = 0;
}

- (void)setPageControl:(UIPageControl *)pageControl
{
	_pageControl = pageControl;
	[_pageControl setNumberOfPages:allPages.count];
	[_pageControl setCurrentPage:currentPageIndex];
	
	[_pageControl addTarget:self
					 action:@selector(scrollToPageControlCurrentPageIndex)
		   forControlEvents:UIControlEventValueChanged];
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
	[self setContentSize:CGSizeMake(self.frame.size.width * numberOfPages, 0)];
	[_pageControl setNumberOfPages:numberOfPages];
}

#warning add ability to perform selector when page is stopped on
- (void)performSelector:(SEL)aSelector
			 withObject:(id)object
 whenStoppedOnPageIndex:(int)index
{
	[selectorsForPages insertObject:NSStringFromSelector(aSelector) atIndex:index];
	[objectsForPages insertObject:object atIndex:index];
}

- (void)scrollToPageIndex:(int)index
{	
    CGRect pageFrame = CGRectMake(self.frame.size.width * index,
								  0,
								  self.frame.size.width,
								  self.frame.size.height);
	
    [self scrollRectToVisible:pageFrame animated:YES];
	
	currentPageIndex = index;
}

- (void)scrollToPreviousPage
{
	[self scrollToPageIndex:currentPageIndex-1];
}

- (void)scrollToNextPage
{
	[self scrollToPageIndex:currentPageIndex+1];
}

- (void)scrollToPageControlCurrentPageIndex
{
	NSInteger toPage = _pageControl.currentPage;
	_pageControl.currentPage = currentPageIndex;
	[self scrollToPageIndex:toPage];
}

#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	// Check if selector is set for page index
	id object;
	SEL selector;
	
	// Ensure currentPageIndex is included in objectsForPages
	if ( [objectsForPages count] > currentPageIndex ) {
		object = [objectsForPages objectAtIndex:currentPageIndex];
	} else {
		return;
	}
	
	// Ensure currentPageIndex is included in selectorsForPages
	if ( [selectorsForPages count] > currentPageIndex ) {
		selector = NSSelectorFromString([selectorsForPages objectAtIndex:currentPageIndex]);
	} else {
		return;
	}
	
	// Perform selector
//	if ( object && selector && [object respondsToSelector:selector] ) {
		[object performSelector:selector];
//	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Calculate the current page index and set it
	currentPageIndex = (int) ( scrollView.contentOffset.x / scrollView.frame.size.width + .5 );
	[_pageControl setCurrentPage:currentPageIndex];
}

@end
