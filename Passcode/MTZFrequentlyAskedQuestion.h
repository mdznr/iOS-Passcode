//
//  MTZFrequentlyAskedQuestion.h
//  Passcode
//
//  Created by Matt on 5/9/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTZFrequentlyAskedQuestion : NSObject

+ (id)faqWithQuestion:(NSString *)question andAnswer:(NSString *)answer;

@property NSString *question;
@property NSString *answer;

@end
