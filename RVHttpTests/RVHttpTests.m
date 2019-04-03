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

@interface RVHttpTest : XCTestCase

@end

@implementation RVHttpTest

- (void)setUp {
    [RVHttp enableTest];
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_fake_url_session_is_used_when_test_enviorenment {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Response is returned"];
    
    [RVFakeUrlSessionDataTask addResponseForUrl:@"http://fake.com"
                                       response:@{@"example":@"example response"}];
    
    [RVHttp get:@"http://fake.com" params:@{} completion:^(RVHttpResponse *response) {
        NSError *error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:response.data options:kNilOptions error:&error];
        XCTAssertTrue(response.data != nil);
        XCTAssertTrue([dict[@"example"] isEqualToString:@"example response"]);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

/**
 * https://httpbin.org/ Web to test requests
 */

-(void)test_can_do_get_request{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET response is returned"];
    
    [RVHttp disableTest];
    [RVHttp get:@"https://httpbin.org/get" params:@{@"name" : @"jordi"} headers:@{@"Custom-Header": @"header-value"} completion:^(RVHttpResponse *response) {
        
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertTrue( isEqual(@"jordi",        responseDict[@"args"][@"name"]) );
        XCTAssertTrue( isEqual(@"header-value", responseDict[@"headers"][@"Custom-Header"]) );
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

-(void)test_can_do_get_request_encoded{
    XCTestExpectation *expectation = [self expectationWithDescription:@"GET response is returned"];
    
    [RVHttp disableTest];
    [RVHttp get:@"https://httpbin.org/get" params:@{@"name" : @"a strange name", @"number" : @2} headers:@{@"Custom-Header": @"header-value"} completion:^(RVHttpResponse *response) {
        
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertTrue( isEqual(@"a strange name",  responseDict[@"args"][@"name"]) );
        XCTAssertTrue( isEqual(@"2",               responseDict[@"args"][@"number"]) );
        XCTAssertTrue( isEqual(@"header-value",    responseDict[@"headers"][@"Custom-Header"]) );
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

-(void)test_can_do_post_request{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"POST response is returned"];
    
    [RVHttp disableTest];
    [RVHttp post:@"https://httpbin.org/post" params:@{@"name" : @"jordi"} headers:@{@"Custom-Header": @"header-value"} completion:^(RVHttpResponse *response) {
        
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertTrue( isEqual(@"jordi", responseDict[@"form"][@"name"]) );
        XCTAssertTrue( isEqual(@"header-value", responseDict[@"headers"][@"Custom-Header"]) );
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

-(void)test_can_do_post_with_body_request{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"POST response is returned"];
    
    [RVHttp disableTest];
    [RVHttp post:@"https://httpbin.org/post" body:@"name=jordi" headers:@{@"Custom-Header": @"header-value"} completion:^(RVHttpResponse *response) {
        
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertTrue( isEqual(@"jordi", responseDict[@"form"][@"name"]) );
        XCTAssertTrue( isEqual(@"header-value", responseDict[@"headers"][@"Custom-Header"]) );
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

-(void)test_can_do_put_request{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"POST response is returned"];
    
    [RVHttp disableTest];
    [RVHttp put:@"https://httpbin.org/put" params:@{@"name" : @"jordi"} headers:@{@"Custom-Header": @"header-value"} completion:^(RVHttpResponse *response) {
        
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertTrue( isEqual(@"jordi", responseDict[@"form"][@"name"]) );
        XCTAssertTrue( isEqual(@"header-value", responseDict[@"headers"][@"Custom-Header"]) );
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

-(void)test_can_do_delete_request{
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"POST response is returned"];
    
    [RVHttp disableTest];
    [RVHttp delete:@"https://httpbin.org/delete" params:nil headers:@{@"Custom-Header": @"header-value"} completion:^(RVHttpResponse *response) {
        
        NSDictionary* responseDict = response.toDictionary;
        XCTAssertTrue( isEqual(@"header-value", responseDict[@"headers"][@"Custom-Header"]) );
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) NSLog(@"Timeout Error: %@", error);
    }];
}

-(void)test_request_can_be_converted_to_string_and_recovered{
    
    RVHttpRequest * request = [RVHttpRequest method:@"GET"
                                                url:@"http://testurl.com"
                                             params:@{@"name":@"jordi"}
                                            headers:@{@"My-Header" : @"header-value"}];
    request.body = @"patata";
    
    NSString* requestString = request.toString;
    RVHttpRequest* newRequest = [RVHttpRequest fromStringDict:requestString];
    
    XCTAssertEqualObjects( request.url,         newRequest.url);
    XCTAssertEqualObjects( request.method,      newRequest.method);
    XCTAssertEqualObjects( request.body,        newRequest.body);
    XCTAssertEqualObjects( request.parameters,  newRequest.parameters);
    XCTAssertEqualObjects( request.headers,     newRequest.headers);
}

-(void)test_can_convert_json_parameter_request{
    RVHttpRequest * request = [RVHttpRequest method:@"GET"
                                                url:@"http://testurl.com"
                                             params:@{@"message":@"%7B%0A%20%20%22request%22%20%3A%20%7B%0A%20%20%20%20%22model%22%20%3A%20%22Order%22%2C%0A%20%20%20%20%22action%22%20%3A%20%22save%22%0A%20%20%7D%2C%0A%20%20%22auth%22%20%3A%20%7B%0A%20%20%20%20%22uuid%22%20%3A%20%2250A36156%2DAD82%2D4FF7%2D802D%2D4803E65FEF12%22%2C%0A%20%20%20%20%22username%22%20%3A%20%22retail%22%2C%0A%20%20%20%20%22password%22%20%3A%20%22retail%22%0A%20%20%7D%2C%0A%20%20%22data%22%20%3A%20%7B%0A%20%20%20%20%22order%22%20%3A%20%7B%0A%20%20%20%20%20%20%22id%22%20%3A%20null%2C%0A%20%20%20%20%20%20%22discount%22%20%3A%200%2C%0A%20%20%20%20%20%20%22invoices%22%20%3A%20%5B%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22id%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%22number%22%20%3A%20%224%2D42%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22order%5Fid%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%22payments%22%20%3A%20%5B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22amount%22%20%3A%2082%2E2%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22id%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22invoice%5Fid%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22payment%5Fmethod%5Fid%22%20%3A%202%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22change%22%20%3A%200%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22extra%22%20%3A%20null%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%20%20%20%20%22turn%5Fid%22%20%3A%20121%2C%0A%20%20%20%20%20%20%20%20%20%20%22created%5Fat%22%20%3A%20%222017%2D03%2D07%2016%3A07%3A08%22%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22tax%22%20%3A%2014%2E26612%2C%0A%20%20%20%20%20%20%22created%5Fat%22%20%3A%20%222017%2D03%2D07%2016%3A07%3A02%22%2C%0A%20%20%20%20%20%20%22discountObject%22%20%3A%20null%2C%0A%20%20%20%20%20%20%22total%22%20%3A%2082%2E2%2C%0A%20%20%20%20%20%20%22subtotal%22%20%3A%2067%2E93388%2C%0A%20%20%20%20%20%20%22orderDiscount%22%20%3A%200%2C%0A%20%20%20%20%20%20%22closed%5Fat%22%20%3A%20%222017%2D03%2D07%2016%3A07%3A08%22%2C%0A%20%20%20%20%20%20%22employee%5Fid%22%20%3A%201%2C%0A%20%20%20%20%20%20%22customer%5Fid%22%20%3A%20null%2C%0A%20%20%20%20%20%20%22contents%22%20%3A%20%5B%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%22quantity%22%20%3A%201%2C%0A%20%20%20%20%20%20%20%20%20%20%22id%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%22discount%22%20%3A%200%2C%0A%20%20%20%20%20%20%20%20%20%20%22taxPercentage%22%20%3A%2021%2C%0A%20%20%20%20%20%20%20%20%20%20%22tax%22%20%3A%2014%2E26612%2C%0A%20%20%20%20%20%20%20%20%20%20%22created%5Fat%22%20%3A%20%222017%2D03%2D07%2016%3A07%3A02%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22discountObject%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%22total%22%20%3A%2082%2E2%2C%0A%20%20%20%20%20%20%20%20%20%20%22weight%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%22order%5Fid%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%22subtotal%22%20%3A%2067%2E93388%2C%0A%20%20%20%20%20%20%20%20%20%20%22price%22%20%3A%2082%2E2%2C%0A%20%20%20%20%20%20%20%20%20%20%22notes%22%20%3A%20null%2C%0A%20%20%20%20%20%20%20%20%20%20%22product%5Fid%22%20%3A%2049%2C%0A%20%20%20%20%20%20%20%20%20%20%22name%22%20%3A%20%22NikeCourt%20CVlassic%20Ultra%20Premium%20%2D%2010%20%2D%20Hot%20Lava%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22sum%22%20%3A%2082%2E2%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%5D%2C%0A%20%20%20%20%20%20%22status%22%20%3A%203%2C%0A%20%20%20%20%20%20%22sum%22%20%3A%2082%2E2%0A%20%20%20%20%7D%2C%0A%20%20%20%20%22warehouse%5Fid%22%20%3A%203%2C%0A%20%20%20%20%22contentIdsToRemove%22%20%3A%20null%0A%20%20%7D%0A%7D"}
                                            headers:@{@"My-Header" : @"header-value"}];
    
    NSString* requestString = request.toString;
    RVHttpRequest* newRequest = [RVHttpRequest fromStringDict:requestString];
    
    XCTAssertEqualObjects( request.url,         newRequest.url);
    XCTAssertEqualObjects( request.method,      newRequest.method);
    XCTAssertEqualObjects( request.parameters,  newRequest.parameters);
    XCTAssertEqualObjects( request.headers,     newRequest.headers);
}

-(void)test_request_can_get_status_code{
    [RVHttp disableTest];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Response is returned"];
    
    [RVHttp get:@"https://httpbin.org/get" params:@{} completion:^(RVHttpResponse *response) {
        XCTAssertEqual(response.statusCode, 200);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void)test_set_custom_session {
    [RVHttp disableTest];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Response is returned"];

    NSURLSessionConfiguration *sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    [RVHttp setUrlSession:session];

    [RVHttp get:@"https://httpbin.org/get" params:@{} completion:^(RVHttpResponse *response) {
        XCTAssertEqual(response.statusCode, 200);
        [expectation fulfill];
    }];

    XCTAssertEqual(session, [RVHttp getUrlSession]);

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
