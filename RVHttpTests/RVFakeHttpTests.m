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

-(void)test_can_have_multiple_responses_and_get_them_in_a_queue{
    [RVHttpFake setResponses:@[
            @{@"hello" : @"world"},
            @{@"hello" : @"me"},
            @{@"hello" : @"everybody"}
    ]];

    XCTestExpectation *expectation1 = [self expectationWithDescription:@"Response is returned"];
    XCTestExpectation *expectation2 = [self expectationWithDescription:@"Response is returned"];
    XCTestExpectation *expectation3 = [self expectationWithDescription:@"Response is returned"];

    [RVHttp post:@"http://hello.com" params:@{} completion:^(RVHttpResponse *response) {
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertNotNil(responseDict);
        XCTAssertEqualObjects(responseDict[@"hello"], @"world");
        [expectation1 fulfill];
    }];

    [RVHttp post:@"http://hello.com" params:@{} completion:^(RVHttpResponse *response) {
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertNotNil(responseDict);
        XCTAssertEqualObjects(responseDict[@"hello"], @"me");
        [expectation2 fulfill];
    }];

    [RVHttp post:@"http://hello.com" params:@{} completion:^(RVHttpResponse *response) {
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertNotNil(responseDict);
        XCTAssertEqualObjects(responseDict[@"hello"], @"everybody");
        [expectation3 fulfill];
    }];

    [self waitForExpectations:@[expectation1,expectation2, expectation3 ] timeout:10];
}
@end