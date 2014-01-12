//
//  MTZSlideToReveal.h
//  Slide to Reveal
//
//  Created by Matt on 4/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZSlideToReveal : UIView

/// The secret word to hide.
@property (nonatomic, assign) NSString *hiddenWord;

/// Pass along gesture recogzniers along to this view via this method.
- (void)didGesture:(UIGestureRecognizer *)sender;

@end
