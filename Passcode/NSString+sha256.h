//
//  NSString+sha256.h
//  Passcode
//
//  Created by Matt on 1/12/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (sha256)

+ (NSString *)base64StringFromData:(NSData *)theData;

- (NSData *)sha256Data;
- (NSString *)sha256;

@end
