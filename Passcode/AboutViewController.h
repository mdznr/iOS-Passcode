//
//  AboutViewController.h
//  Passcode
//
//  Created by Matt on 8/13/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *howTo;
@property (strong, nonatomic) IBOutlet UILabel *tips;
@property (strong, nonatomic) IBOutlet UIButton *passcodeURL;

- (IBAction)done:(id)sender;

@end
