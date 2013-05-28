//
//  PCDPasscodeGenerator.h
//  Passcode
//
//  Created by Matt on 5/27/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCDPasscodeGenerator : NSObject

// The desired length of the generated passcode
@property (nonatomic) NSUInteger length; // Defaults to 16

@property (nonatomic) BOOL atleastOneCapital;
@property (nonatomic) BOOL atleastOneLowercase;
@property (nonatomic) BOOL atleastOneNumber;
@property (nonatomic) BOOL atleastOneSymbol;

+ (id)sharedInstance;
- (NSString *)passcodeForDomain:(NSString *)domain andMasterPassword:(NSString *)masterPassword;

@end
