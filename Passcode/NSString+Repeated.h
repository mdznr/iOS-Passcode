//
//  NSString+Repeated.h
//  Passcode
//
//  Created by Matt Zanchelli on 1/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Repeated)

/// Create a string by repeating a string a specified number of times.
/// @param string The string to repeat.
/// @param numberOfTimes The number of times to repeat the string.
/// @return A newly created string by repeating the specified string a specified number of times.
+ (NSString *)stringByRepeatingString:(NSString *)string numberOfTimes:(NSUInteger)numberOfTimes;

/// Insert a string throughout the receiver.
/// @param string The string to insert throughout the receiver.
/// @param numberOfCharacters The interval at which to repeat the specified string throughout the receiver.
/// @return A newly created string by inserting the specified string throughout the receiver.
/// @discussion Can be used in creating chunks/groups out of the receving string.
- (NSString *)stringByInsertingString:(NSString *)string everyNumberOfCharacters:(NSUInteger)numberOfCharacters;

@end
