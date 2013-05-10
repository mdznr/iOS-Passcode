//
//  PCDFAQView.h
//  Passcode
//
//  Created by Matt on 5/8/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTZFrequentlyAskedQuestion.h"

@interface PCDFAQView : UIView

- (void)setQuestionText:(NSString *)questionText andAnswerText:(NSString *)answerText;
- (void)setFAQ:(MTZFrequentlyAskedQuestion *)faq;

@end
