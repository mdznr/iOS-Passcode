//
//  PCDFAQViewController.m
//  Passcode
//
//  Created by Matt on 5/8/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDFAQViewController.h"
#import "PCDFAQView.h"
#import "NSMutableArray+MTZRemove.h"

@interface PCDFAQViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *questionsAndAnswers;

@property (strong, nonatomic) NSString *localPath;

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
	_localPath = [NSString stringWithFormat:@"%@/%@.plist", documentsDirectory, _fileName];
	
	BOOL fileExistsInDocuments = [[NSFileManager defaultManager] fileExistsAtPath:_localPath];
	if ( !fileExistsInDocuments ) {
		// Copy file from app bundle to documents
		NSString *p = [[NSBundle mainBundle] pathForResource:_fileName ofType:@"plist"];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForUpdates
{
	
	NSURL *url = [NSURL URLWithString:_remoteURL];
	
#if DEBUG
	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestReloadIgnoringCacheData
										 timeoutInterval:10.0f];
#else
	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:10.0f];
#endif
	
	[NSURLConnection sendAsynchronousRequest:request
									   queue:[NSOperationQueue new]
						   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
							   if ( [data isEqualToData:[[NSData alloc] initWithContentsOfFile:_localPath]] ) {
								   NSLog(@"SAME");
							   } else {
								   NSLog(@"NOT SAME");
								   // Save content to the documents directory
								   [data writeToFile:_localPath atomically:YES];
								   [self reloadTableView];
							   }
						   }];
}

- (void)reloadTableView
{	
	dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableArray *localCopy = [[NSMutableArray alloc] initWithContentsOfFile:_localPath];
		NSMutableArray *additions = [[NSMutableArray alloc] initWithArray:localCopy];
		NSMutableArray *deletions = [[NSMutableArray alloc] initWithArray:_questionsAndAnswers];
		[deletions removeFirstOfEachObjectInArray:additions];
		[additions removeFirstOfEachObjectInArray:_questionsAndAnswers];
		
		NSLog(@"+%lu -%lu", (unsigned long)deletions.count, (unsigned long)additions.count);
		
		[self.tableView beginUpdates];
		for ( NSUInteger i=0; i<_questionsAndAnswers.count; ++i ) {
			NSUInteger index = [deletions indexOfObject:_questionsAndAnswers[i]];
			if ( index != NSNotFound ) {
				[deletions removeObjectAtIndex:index];
				[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]
									  withRowAnimation:UITableViewRowAnimationRight];
				NSLog(@"Fading out %lu", (unsigned long)i);
			}
		}
		
		_questionsAndAnswers = [[NSMutableArray alloc] initWithArray:localCopy];
		
		for ( NSUInteger i=0; i<_questionsAndAnswers.count; ++i ) {
			NSUInteger index = [additions indexOfObject:_questionsAndAnswers[i]];
			if ( index != NSNotFound ) {
				[additions removeObjectAtIndex:index];
				[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]
									  withRowAnimation:UITableViewRowAnimationRight];
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
