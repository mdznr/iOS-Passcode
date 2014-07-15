//
//  PCDUnifiedGeneratorViewController.h
//  Passcode
//
//  Created by Matt Zanchelli on 7/15/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

@import UIKit;

#import "PCDPasscodeGeneratorViewControllerProtocol.h"

@interface PCDUnifiedGeneratorViewController : UIViewController <PCDPasscodeGeneratorViewControllerProtocol>

- (void)setServiceName:(NSString *)serviceName;

@end
