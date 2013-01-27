//
//  PCDAboutViewControllerDelegate.h
//  Passcode
//
//  Created by Matt on 1/17/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PCDAboutViewControllerDelegate <NSObject>

- (void)dismissingModalViewController:(id)sender;
- (void)startWalkthrough:(id)sender;

@end
