//
//  MTZSlideToReveal.h
//  Slide to Reveal
//
//  Created by Matt on 4/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	MTZSlideToRevealSizeiPhone,
	MTZSlideToRevealSizeiPad
} MTZSlideToRevealSize;

@interface MTZSlideToReveal : UIView

@property MTZSlideToRevealSize size;
@property (nonatomic, assign) NSString *word;

- (void)didGesture:(id)sender;

@end
