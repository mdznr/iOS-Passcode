//
//  AboutViewController.h
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

- (IBAction)done:(id)sender;
- (IBAction)howToUse;
- (IBAction)faq;
- (IBAction)showSupport;

@end
