//
//  PCDPasscodeGeneratorViewControllerProtocol.h
//  Passcode
//
//  Created by Matt Zanchelli on 7/15/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

@import UIKit;

@protocol PCDPasscodeGeneratorViewControllerProtocol <NSObject>

/// Set the name of the service.
- (void)setServiceName:(NSString *)serviceName;

@end