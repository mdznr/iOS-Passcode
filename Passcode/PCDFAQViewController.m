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
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"Are passwords being sent to a server?"
																	  andAnswer:@"No. No data is ever sent to or from Passcode. All passwords are generated using code within the app itself. Password and other usage data are never sent outside of the app."]];
	
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"Is Passcode available on other platforms?"
																	  andAnswer:@"Yes! Passcode is available on several other platforms. Information on where to get these apps is available on *http://passcod.es*."]];
	
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"After generating a passcode, how can it be retrieved again?"
																	  andAnswer:@"Simply generate it again. Using the same domain and master password, this app will always generate the same output."]];
	
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"Can the master password be found from the generated passcode?"
																	  andAnswer:@"No. Passcode uses an algorithm that cannot be reversed. Generated passcodes can be used without the possibility of someone figuring out the master password."]];
	
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"How is this different than 1Password?"
																	  andAnswer:@"The 1Password app randomly generates passwords and stores them in a database. That's data that can be lost or stolen. If the database file is lost or becomes corrupted, access to all accounts can be gone forever. Or even worse, if that database is compromised, someone else may have access to your accounts.\nPasscode generates passcodes on the fly every time they're needed and are not stored. Passcode also works offline and doesn't require syncing between platforms."]];
	
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"Is there a faster way to enter the domain field?"
																	  andAnswer:@"Opening the app with a proper URL in the clipboard will automatically fill the domain field. A bookmarklet can also be added to your web browser to open Passcode with the domain of the current page. *[Include information on how to install javascript bookmarklet].*"]];
	
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"How is this app free?"
																	  andAnswer:@"Passcode is developed by *students* as part of a research program at *Rensselaer Polytechnic Institute*. The source code is *open-souce*. Students gain knowledge and experience, and users get free software. Everyone wins."]];
	
	[_questionsAndAnswers addObject:[MTZFrequentlyAskedQuestion faqWithQuestion:@"How can I thank you?"
																	  andAnswer:@"You can help by kindly donating. Or, if you have software development experience, you can help by contributing to the development of this project for other platforms. Visit *http://passcod.es* for more information."]];
	
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
