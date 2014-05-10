//
//  PCDDomainName.m
//  Passcode
//
//  Created by Matt Zanchelli on 5/10/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURL+DomainName.h"

@interface PCDDomainName : XCTestCase

@end

@implementation PCDDomainName

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDomainName
{
	NSString *domainName = @"apple";
	NSArray *fullURLs = @[
						  @"http://apple.com",
						  @"http://apple.com/",
						  @"http://apple.com/index.html",
						  @"http://apple.com/store/index.html",
						  
						  @"http://www.apple.com",
						  @"http://www.apple.com/",
						  @"http://www.apple.com/index.html",
						  @"http://www.apple.com/store/index.html",
						  
						  @"http://www.subdomain.apple.com",
						  @"http://www.subdomain.apple.com/",
						  @"http://www.subdomain.apple.com/index.html",
						  @"http://www.subdomain.apple.com/store/index.html",
						  
						  @"http://www.apple.co.uk",
						  @"http://www.apple.co.uk/",
						  @"http://www.apple.co.uk/index.html",
						  @"http://www.apple.co.uk/store/index.html",
						  
						  @"http://www.apple.org.uk",
						  @"http://www.apple.org.uk/",
						  @"http://www.apple.org.uk/index.html",
						  @"http://www.apple.org.uk/store/index.html",
						  
						  @"https://apple.com",
						  @"https://apple.com/",
						  @"https://apple.com/index.html",
						  @"https://apple.com/store/index.html",
						  
						  @"https://www.apple.com",
						  @"https://www.apple.com/",
						  @"https://www.apple.com/index.html",
						  @"https://www.apple.com/store/index.html",
						  
						  @"https://www.subdomain.apple.com",
						  @"https://www.subdomain.apple.com/",
						  @"https://www.subdomain.apple.com/index.html",
						  @"https://www.subdomain.apple.com/store/index.html",
						  
						  @"https://www.apple.co.uk",
						  @"https://www.apple.co.uk/",
						  @"https://www.apple.co.uk/index.html",
						  @"https://www.apple.co.uk/store/index.html",
						  
						  @"https://www.apple.org.uk",
						  @"https://www.apple.org.uk/",
						  @"https://www.apple.org.uk/index.html",
						  @"https://www.apple.org.uk/store/index.html",
						  ];
	
	for ( NSString *fullURL in fullURLs ) {
		NSString *result = [[NSURL URLWithString:fullURL] domainName];
		XCTAssertEqualObjects(domainName, result, @"NSURL's domainName output not correct.");
	}
}

@end
