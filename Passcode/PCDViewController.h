//
//  PCDViewController.h
//  Passcode
//
//  Created by Matt on 8/7/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCDPasscodeGeneratorViewControllerProtocol.h"

@interface PCDViewController : UIViewController

/// A child view controller shown to generate passcodes.
@property (strong, nonatomic) UIViewController<PCDPasscodeGeneratorViewControllerProtocol> *generatorViewController;

@end
