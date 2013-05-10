//
//  MTZFrequentlyAskedQuestion.m
//  Passcode
//
//  Created by Matt on 5/9/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZFrequentlyAskedQuestion.h"

@implementation MTZFrequentlyAskedQuestion

+ (id)faqWithQuestion:(NSString *)question andAnswer:(NSString *)answer
{
	MTZFrequentlyAskedQuestion *faq = [[MTZFrequentlyAskedQuestion alloc] init];
	[faq setQuestion:question];
	[faq setAnswer:answer];
	return faq;
}

@end
