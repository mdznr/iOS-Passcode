//
//  MTZSlideToReveal.h
//  Slide to Reveal
//
//  Created by Matt on 4/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZSlideToReveal : UIView

@property (nonatomic, assign) NSString *word;

- (void)didGesture:(id)sender;

@end
