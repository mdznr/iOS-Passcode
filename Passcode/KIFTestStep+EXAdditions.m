//
//  KIFTestStep+EXAdditions.m
//  Testable
//
//  Created by Eric Firestone on 6/13/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestStep+EXAdditions.h"

@implementation KIFTestStep (EXAdditions)

#pragma mark - Factory Steps

+ (id)stepToReset;
{
    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
        BOOL successfulReset = YES;
        
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
		[self stepsToClearFields];
        
        KIFTestCondition(successfulReset, error, @"Failed to reset some part of the application.");
        
        return KIFTestStepResultSuccess;
    }];
}

#pragma mark - Step Collections

+ (NSArray *)stepsToClearFields;
{
    NSMutableArray *steps = [NSMutableArray array];

	[steps addObject:[KIFTestStep stepToDeleteTextInViewWithAccessibilityLabel:@"Domain" traits:nil]];
	[steps addObject:[KIFTestStep stepToDeleteTextInViewWithAccessibilityLabel:@"Master Password" traits:nil]];
    
    return steps;
}

@end
