//
//  PCDFAQViewController.h
//  Passcode
//
//  Created by Matt Zanchelli on 12/30/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCDFAQViewController : UITableViewController

// The location of the plist to check remotely
// Include .plist, if necessary
@property (strong, nonatomic) NSString *remoteURL;

// The name of the file (do not include .plist extension)
// Defaults to @"FAQs"
@property (strong, nonatomic) NSString *fileName;

@end
