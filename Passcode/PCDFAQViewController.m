//
//  PCDFAQViewController.m
//  Passcode
//
//  Created by Matt on 5/8/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDFAQViewController.h"
#import "PCDFAQView.h"

@interface PCDFAQViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *questionsAndAnswers;

@end

@implementation PCDFAQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
		[self setup];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		[self setup];
    }
    return self;
}

- (void)setup
{
	[self setTitle:@"FAQs"];
	
	// Path to the plist (in the application bundle)
	NSString *path = [[NSBundle mainBundle] pathForResource:@"FAQs" ofType:@"plist"];
	
	_questionsAndAnswers = [[NSMutableArray alloc] initWithContentsOfFile:path];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	[_tableView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_tableView setContentInset:UIEdgeInsetsMake(4, 0, 4, 0)];
	[_tableView setBackgroundColor:[UIColor colorWithWhite:0.93f alpha:1.0f]];
	
	[self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *x = _questionsAndAnswers[indexPath.row];
	CGSize q = [[x objectForKey:@"Question"] sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
										constrainedToSize:CGSizeMake(280.0f, FLT_MAX)
											lineBreakMode:NSLineBreakByWordWrapping];
	
	CGSize a = [[x objectForKey:@"Answer"] sizeWithFont:[UIFont systemFontOfSize:14.0f]
									  constrainedToSize:CGSizeMake(280.0f, FLT_MAX)
										  lineBreakMode:NSLineBreakByWordWrapping];
	
	CGFloat totalHeight = q.height + a.height + 34; // 34 is for paddings
	
	return totalHeight;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *c = [[UITableViewCell alloc] init];
	[c setSelectionStyle:UITableViewCellSelectionStyleNone];
	PCDFAQView *faqView = [[PCDFAQView alloc] initWithFrame:CGRectMake(8, 5, 304, 118)];
	NSDictionary *x = _questionsAndAnswers[indexPath.row];
	[faqView setQuestionText:[x objectForKey:@"Question"]
			   andAnswerText:[x objectForKey:@"Answer"]];
	[c.contentView addSubview:faqView];
	
	return c;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _questionsAndAnswers.count;
}

@end
