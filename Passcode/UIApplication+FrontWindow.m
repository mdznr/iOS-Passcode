//
//  UIApplication+FrontWindow.m
//  Passcode
//
//  Created by Matt on 8/16/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import "UIApplication+FrontWindow.h"

@implementation UIApplication (FrontWindow)

- (void)addSubViewOnFrontWindow:(UIView *)view
{
    int count = [self.windows count];
    UIWindow *w = [self.windows objectAtIndex:count - 1];
    [w addSubview:view];
}

@end
