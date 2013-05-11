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

@property (strong, nonatomic) NSString *localPath;
@property BOOL toggle;

@end

@implementation PCDFAQViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self setTitle:@"FAQs"];
	
	// Get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// Path to FAQs plist
	_localPath = [NSString stringWithFormat:@"%@/FAQs.plist", documentsDirectory];
	
	BOOL fileExistsInDocuments = [[NSFileManager defaultManager] fileExistsAtPath:_localPath];
	if ( !fileExistsInDocuments ) {
		// Copy file from app bundle to documents
		NSString *p = [[NSBundle mainBundle] pathForResource:@"FAQs" ofType:@"plist"];
		[[NSFileManager defaultManager] copyItemAtPath:p toPath:_localPath error:nil];
	}
	
	// Inititalise array with plist
	_questionsAndAnswers = [[NSMutableArray alloc] initWithContentsOfFile:_localPath];
	
	
	[self checkForUpdates];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	[_tableView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
	[_tableView setDelegate:self];
	[_tableView setDataSource:self];
	[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_tableView setContentInset:UIEdgeInsetsMake(4, 0, 4, 0)];
	[_tableView setBackgroundColor:[UIColor colorWithWhite:0.93f alpha:1.0f]];
	
	[self.view addSubview:_tableView];
	
	
	// ***
	UIBarButtonItem *toggle = [[UIBarButtonItem alloc] initWithTitle:@"Toggle"
															   style:UIBarButtonItemStyleBordered
															  target:self
															  action:@selector(toggler)];
	[self.navigationItem setRightBarButtonItem:toggle];
}

- (void)toggler
{
	NSLog(@"Toggle");
	
	// Get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	// set plist file
	if ( _toggle ) {
		_localPath = [NSString stringWithFormat:@"%@/FAQs.plist", documentsDirectory];
	} else {
		_localPath = [NSString stringWithFormat:@"%@/FAQs2.plist", documentsDirectory];
	}
	
	_toggle = !_toggle;
	
	// reload
	[self reloadTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForUpdates
{
	//	NSURL *url = [NSURL URLWithString:@"https://raw.github.com/mdznr/iOS-Passcode/master/FAQs.plist"];
	NSURL *url = [NSURL URLWithString:@"http://mdznr.com/FAQs.plist"];
	//  NSURLRequestUseProtocolCachePolicy
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue new]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
							   if ( [data isEqualToData:[[NSData alloc] initWithContentsOfFile:_localPath]] ) {
								   NSLog(@"SAME");
							   } else {
								   NSLog(@"NOT SAME");
								   // Save content to the documents directory
								   [data writeToFile:_localPath atomically:NO];
								   
								   [self reloadTableView];
							   }
						   }];
}

- (void)reloadTableView
{	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSMutableArray *additions = [[NSMutableArray alloc] initWithContentsOfFile:_localPath];
		NSMutableArray *deletions = [[NSMutableArray alloc] initWithArray:_questionsAndAnswers];
		[deletions removeObjectsInArray:additions];
		[additions removeObjectsInArray:_questionsAndAnswers];
		
		NSLog(@"%lu %lu", (unsigned long)deletions.count, (unsigned long)additions.count);
		
		NSUInteger oldCount = [_questionsAndAnswers count];
		
		[self.tableView beginUpdates];
		for ( NSUInteger i=0; i<oldCount; ++i ) {
			if ( [deletions containsObject:_questionsAndAnswers[i]] ) {
				[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]
									  withRowAnimation:UITableViewRowAnimationFade];
				NSLog(@"Fading out %lu", (unsigned long)i);
			}
		}
		
		_questionsAndAnswers = [[NSMutableArray alloc] initWithContentsOfFile:_localPath];
		NSUInteger newCount = [_questionsAndAnswers count];
		
		for ( NSUInteger i=0; i<newCount; ++i ) {
			if ( [additions containsObject:_questionsAndAnswers[i]] ) {
				[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]
									  withRowAnimation:UITableViewRowAnimationTop];
				NSLog(@"Fading in %lu", (unsigned long)i);
			}
		}
		[self.tableView endUpdates];
	});
	
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
