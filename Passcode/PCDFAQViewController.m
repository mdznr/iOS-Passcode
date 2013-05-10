//
//  PCDFAQViewController.m
//  Passcode
//
//  Created by Matt on 5/8/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDFAQViewController.h"
#import "PCDFAQView.h"
#import "MTZFrequentlyAskedQuestion.h"

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
	_questionsAndAnswers = [[NSMutableArray alloc] initWithCapacity:4];
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"1This is a question that may span multiple lines."
																	  andAnswer:@"1This is an answer to the question above. This answer may also span multiple lines. Maybe even three or four lines long this answer can be. oh em gee. Lorem ipsum dolor sit amet."]];
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"2This is a question that may span multiple lines. Lorem ipsum dolor sit amet jklsdfljksdfjkldfsjklfsdljksdfjkldfsjklfsdjklfsdkjlsfdjlksfd"
																	  andAnswer:@"2This is an answer to the question above."]];
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"3This is a question that may span multiple lines. Wah wah wah wah wah wah wah wah"
																	  andAnswer:@"3This is an answer to the question above."]];
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"4This is a question that may span multiple lines."
																	  andAnswer:@"4This is an answer to the question above."]];
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"5This is a question that may span multiple lines."
																	  andAnswer:@"5This is an answer to the question above."]];
	
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
	MTZFrequentlyAskedQuestion *x = _questionsAndAnswers[indexPath.row];
	CGSize q = [x.question sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
					  constrainedToSize:CGSizeMake(280.0f, FLT_MAX)
						  lineBreakMode:NSLineBreakByWordWrapping];
	
	CGSize a = [x.answer sizeWithFont:[UIFont systemFontOfSize:14.0f]
					constrainedToSize:CGSizeMake(280.0f, FLT_MAX)
						lineBreakMode:NSLineBreakByWordWrapping];
	
	CGFloat totalHeight = q.height + a.height + 33; // 33 is for paddings
	
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
	PCDFAQView *faqView = [[PCDFAQView alloc] initWithFrame:CGRectMake(8, 5, 304, 118)];
	[faqView setFAQ:_questionsAndAnswers[indexPath.row]];
	[c.contentView addSubview:faqView];
	
	return c;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _questionsAndAnswers.count;
}

@end
