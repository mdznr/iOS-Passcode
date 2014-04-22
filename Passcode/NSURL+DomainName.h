//
//  NSURL+DomainName.h
//  Passcode
//
//  Created by Matt Zanchelli on 4/22/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (DomainName)

///	The domain name.
///	@return The name of the domain.
- (NSString *)domainName;

@end
