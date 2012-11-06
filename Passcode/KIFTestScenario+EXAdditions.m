//
//  KIFTestScenario+EXAdditions.m
//  Testable
//
//  Created by Eric Firestone on 6/12/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestScenario+EXAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+EXAdditions.h"

@implementation KIFTestScenario (EXAdditions)

+ (id)scenarioToGeneratePasscode;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully generate a password."];
	
	[scenario addStep:[KIFTestStep stepToDeleteTextInViewWithAccessibilityLabel:@"Domain" traits:nil]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"apple" intoViewWithAccessibilityLabel:@"Domain"]];
	
	[scenario addStep:[KIFTestStep stepToDeleteTextInViewWithAccessibilityLabel:@"Master Password" traits:nil]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"thisismypassword" intoViewWithAccessibilityLabel:@"Master Password"]];
    
	[scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Generate Passcode and Copy"]];
    
    // Verify that the generation succeeded
	[scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Passcode Copied"]];
    
    return scenario;
}

@end
