//
//  PCDFAQViewController.m
//  Passcode
//
//  Created by Matt Zanchelli on 12/30/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDFAQViewController.h"

#import "PCDFAQCell.h"

#import "NSMutableArray+MTZRemove.h"

@interface PCDFAQViewController ()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *questionsAndAnswers;

@property (strong, nonatomic) NSString *localPath;

@end

@implementation PCDFAQViewController

static NSString *cellIdentifier = @"PCDFAQCell";

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// Listen to UIContentSizeCategoryDidChangeNotification (Dynamic Type)
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(preferredContentSizeDidChange:)
												 name:UIContentSizeCategoryDidChangeNotification
											   object:nil];
	
	self.title = NSLocalizedString(@"FAQs", @"FAQs");
	
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

// Dynamic type size changed
- (void)preferredContentSizeDidChange:(id)sender
{
	[self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _questionsAndAnswers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Total height to return
	CGFloat totalHeight = 0;
	
	// Top padding
	totalHeight += 10;
	
	// Get question and answer strings
	NSDictionary *x = _questionsAndAnswers[indexPath.row];
	
	
	// Question
	NSString *question = [x objectForKey:@"Question"];
	UIFont *questionFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
	CGRect r;
	r = [question boundingRectWithSize:(CGSize){290, CGFLOAT_MAX}
							   options:NSStringDrawingUsesLineFragmentOrigin
							attributes:@{NSFontAttributeName: questionFont}
							   context:nil];
	totalHeight += r.size.height;
	
	
	// Add padding between labels
	totalHeight += 8;
	
	
	// Answer
	NSString *answer = [x objectForKey:@"Answer"];
	UIFont *answerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
	r = [answer boundingRectWithSize:(CGSize){290, CGFLOAT_MAX}
							 options:NSStringDrawingUsesLineFragmentOrigin
						  attributes:@{NSFontAttributeName: answerFont}
							 context:nil];
	totalHeight += r.size.height;
	
	
	// Bottom padding
	totalHeight += 12;
	
	return totalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PCDFAQCell *cell = (PCDFAQCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	NSDictionary *x = _questionsAndAnswers[indexPath.row];
	
	NSString *question = [x objectForKey:@"Question"];
	CGSize size;
	CGRect rect;
	UIFont *questionFont = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
	CGRect r;
	r = [question boundingRectWithSize:(CGSize){290, CGFLOAT_MAX}
							   options:NSStringDrawingUsesLineFragmentOrigin
							attributes:@{NSFontAttributeName: questionFont}
							   context:nil];
	size = r.size;
	cell.questionLabel.font = questionFont;
	cell.questionLabel.text = question;
	rect = cell.questionLabel.frame;
	cell.questionLabel.frame = CGRectMake(rect.origin.x, rect.origin.y, 290, size.height);
	
	NSString *answer = [x objectForKey:@"Answer"];
	UIFont *answerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
	r = [answer boundingRectWithSize:(CGSize){290, CGFLOAT_MAX}
							 options:NSStringDrawingUsesLineFragmentOrigin
						  attributes:@{NSFontAttributeName: answerFont}
							 context:nil];
	size = r.size;
	
	cell.answerLabel.font = answerFont;
	cell.answerLabel.text = answer;
	rect = cell.answerLabel.frame;
	cell.answerLabel.frame = CGRectMake(rect.origin.x, CGRectGetMaxY(cell.questionLabel.frame) + 8, 290, size.height);
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Table view delegate


#pragma mark - UIViewController Misc.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
