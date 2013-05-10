//
//  PCDFAQView.m
//  Passcode
//
//  Created by Matt on 5/8/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDFAQView.h"

@interface PCDFAQView ()

@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UILabel *answerLabel;
@property (strong, nonatomic) UIImageView *backgroundQuestion;
@property (strong, nonatomic) UIImageView *backgroundMain;

@end

@implementation PCDFAQView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (id)init
{
	self = [super init];
    if (self) {
        // Initialization code
		[self setup];
    }
    return self;
}

- (void)setup
{
	[self setOpaque:NO];
	
	_backgroundMain = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 304, 170)];
	UIImage *main = [UIImage imageNamed:@"FAQBackgroundMain"];
	[_backgroundMain setImage:[main resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 7, 6)]];
	[self addSubview:_backgroundMain];
	
	_backgroundQuestion = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 300, 39)];
	UIImage *question = [UIImage imageNamed:@"FAQBackgroundQuestion"];
	[_backgroundQuestion setImage:[question resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
	[self addSubview:_backgroundQuestion];
	
	_questionLabel = [[UILabel alloc] init];
	[_questionLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
	[_questionLabel setBackgroundColor:[UIColor clearColor]];
	[_questionLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[_questionLabel setNumberOfLines:FLT_MAX];
	[self addSubview:_questionLabel];
	
	_answerLabel = [[UILabel alloc] init];
	[_answerLabel setFont:[UIFont systemFontOfSize:14.0f]];
	[_answerLabel setBackgroundColor:[UIColor clearColor]];
	[_answerLabel setLineBreakMode:NSLineBreakByWordWrapping];
	[_answerLabel setNumberOfLines:FLT_MAX];
	[self addSubview:_answerLabel];
}

- (void)setQuestionText:(NSString *)questionText andAnswerText:(NSString *)answerText
{
	CGSize s;
	
	[_questionLabel removeFromSuperview];
	[_questionLabel setText:questionText];
	s = [questionText sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]
				 constrainedToSize:CGSizeMake(280.0f, FLT_MAX)
					 lineBreakMode:NSLineBreakByWordWrapping];
	[_questionLabel setFrame:CGRectMake(10, 8, 280, s.height)];
	[self addSubview:_questionLabel];
	
	[_backgroundQuestion setFrame:CGRectMake(2, 2, 300, s.height + 12)]; // Height + 12 for top and bottom padding.
	
	[_answerLabel removeFromSuperview];
	[_answerLabel setText:answerText];
	s = [answerText sizeWithFont:[UIFont systemFontOfSize:14.0f]
			   constrainedToSize:CGSizeMake(280.0f, FLT_MAX)
				   lineBreakMode:NSLineBreakByWordWrapping];
	[_answerLabel setFrame:CGRectMake(10, _backgroundQuestion.frame.origin.y + _backgroundQuestion.frame.size.height + 4, 280, s.height)];
	[self addSubview:_answerLabel];
	
	[_backgroundMain setFrame:CGRectMake(0, 0, 304, _answerLabel.frame.origin.y + s.height + 8)];
	
	CGRect r = self.frame;
	[self setFrame:CGRectMake(r.origin.x, r.origin.y, 304, _backgroundMain.frame.origin.y + _backgroundMain.frame.size.height)];
}

@end
