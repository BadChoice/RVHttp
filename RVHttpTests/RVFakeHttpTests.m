//
//  NetworkTest.m
//  RVUtils
//
//  Created by Jordi Puigdellívol on 15/12/16.
//  Copyright © 2016 Revo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RVFakeUrlSessionDataTask.h"
#import "RVHttpRequest.h"
#import "RVCollection.h"
#import "RVHttp.h"
#import "RVHttpFake.h"

@interface RVFakeHttpTest : XCTestCase

@end

@implementation RVFakeHttpTest

- (void)setUp {
    [super setUp];
    [RVHttpFake enable];
}

- (void)tearDown {
    [RVHttpFake disable];
    [super tearDown];
}

-(void)test_can_stub_for_specific_request{
    [RVHttpFake setResponseFor:@"http://hello.com" response:@{@"hello": @"world"}];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Response is returned"];

    [RVHttp post:@"http://hello.com" params:@{} completion:^(RVHttpResponse *response) {
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertNotNil(responseDict);
        XCTAssertEqualObjects(responseDict[@"hello"], @"world");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void)test_can_stub_for_all_requests {
    [RVHttpFake setResponse:@{@"hello" : @"world"}];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Response is returned"];

    [RVHttp post:@"http://hello.com" params:@{} completion:^(RVHttpResponse *response) {
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertNotNil(responseDict);
        XCTAssertEqualObjects(responseDict[@"hello"], @"world");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end