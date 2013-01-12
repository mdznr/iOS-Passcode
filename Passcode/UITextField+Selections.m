//
//  UITextField+Selections.m
//  Passcode
//
//  Created by Matt on 1/12/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "UITextField+Selections.h"

@implementation UITextField (Selections)

- (NSRange)selectedRange
{
    UITextPosition* beginning = self.beginningOfDocument;
	
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
	
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
	
    return NSMakeRange(location, length);
}

- (void)setSelectedRange:(NSRange)range
{
    UITextPosition* beginning = self.beginningOfDocument;
	
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
	
    [self setSelectedTextRange:selectionRange];
}

- (void)moveCursorToEnd
{	
	[self setSelectedRange:NSMakeRange(self.text.length, 0)];
}

- (void)moveCursorToBeginning
{
	[self setSelectedRange:NSMakeRange(0, 0)];
}

@end
