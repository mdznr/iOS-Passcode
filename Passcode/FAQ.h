//
//  FAQ.h
//  Passcode
//
//  Created by Matt on 10/12/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQ : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *faqText;

- (IBAction)done:(id)sender;

@end
