//
//  UITextField+Selections.h
//  Passcode
//
//  Created by Matt on 1/12/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Selections)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange)range;
- (void)moveCursorToEnd;
- (void)moveCursorToBeginning;

@end
