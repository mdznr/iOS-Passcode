//
//  NSString+characterSwaps.h
//  test
//
//  Created by Matt on 2/3/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (characterSwaps)

- (NSString *)stringByReplacingOccurrencesOfCharacter:(const unichar)fromCharacter withCharacter:(const unichar)toCharacter;

@end
