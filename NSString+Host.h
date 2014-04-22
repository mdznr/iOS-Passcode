//
//  NSString+Host.h
//  Passcode
//
//  Created by Matt Zanchelli on 4/21/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Host)

///	The part of the url string containing the host.
///	@return A string representing the host in the url string or @c nil if not valid.
/// @discussion Ex: @"http://www.apple.com/index.html" returns @"apple"."
- (NSString *)hostString;

@end
