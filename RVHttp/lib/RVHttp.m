//
//  RVNetwork.m
//  Revo
//
//  Created by Jordi Puigdellívol on 20/7/16.
//  Copyright © 2016 Gloobus Studio. All rights reserved.
//

#import "RVHttp.h"
#import "RVHttpRequest.h"
#import "RVFakeUrlSession.h"
#import "RVCollection.h"

static BOOL disable_testing;

@implementation RVHttp

+(void)post:(NSString*)url params:(NSDictionary*)params completion:(void (^)(RVHttpResponse *response))completion
{
    RVHttpRequest *request = [RVHttpRequest method:@"POST" url:url params:params];
    [self call:request completion:completion];
}

+(void)post:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion
{
    RVHttpRequest *request = [RVHttpRequest method:@"POST" url:url params:params headers:headers];
    [self call:request completion:completion];
}

+(void)post:(NSString*)url body:(NSString*)body completion:(void (^)(RVHttpResponse* response))completion
{
    [self.class post:url body:body headers:nil completion:completion];
}

+(void)postJson:(NSString*)url body:(NSString*)body completion:(void (^)(RVHttpResponse* response))completion
{
    [self.class post:url body:body headers:@{@"Content-Type":@"application/json"} completion:completion];
}

+(void)post:(NSString*)url body:(NSString*)body headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion
{
    RVHttpRequest *request = [RVHttpRequest method:@"POST" url:url params:nil headers:headers];
    request.body = body;
    [self call:request completion:completion];
}

+(void)put:(NSString*)url params:(NSDictionary*)params completion:(void (^)(RVHttpResponse* response))completion
{
    [self put:url params:params headers:nil completion:completion];
}

+(void)put:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion
{
    RVHttpRequest *request = [RVHttpRequest method:@"PUT" url:url params:params headers:headers];
    [self call:request completion:completion];
}

+(void)delete:(NSString*)url completion:(void (^)(RVHttpResponse* response))completion
{
    [self.class delete:url params:nil headers:nil completion:completion];
}

+(void)delete:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion
{
    RVHttpRequest *request = [RVHttpRequest method:@"DELETE" url:url params:params headers:headers];
    [self call:request completion:completion];
}

+(void)get:(NSString*)url params:(NSDictionary*)params completion:(void (^)(RVHttpResponse *response))completion
{
    [self.class get:url params:params headers:nil completion:completion];
}

+(void)get:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse *response))completion
{
    RVHttpRequest *request = [RVHttpRequest method:@"GET" url:url params:params headers:headers];
    [self call:request completion:completion];
}

+(void)call:(RVHttpRequest*)theRequest completion:(void (^)(RVHttpResponse *response))completion
{
    NSMutableURLRequest* request = [theRequest generate];
        
    NSURLSession *session           = [self.class getUrlSession];
    NSURLSessionDataTask *dataTask  = [session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *urlResponse, NSError *error)
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               if(completion) {
                                                   RVHttpResponse *response = [[RVHttpResponse alloc] initWithData:data response:urlResponse error:error];
                                                   completion(response);
                                               }
                                           });
                                       }];
    
    [dataTask resume];
}

/**
 * To use fake request calls set the enviornmentvariable as @"TESTING"
 */
+(NSURLSession*)getUrlSession{
    if([self.class isRunningUnitTests]){
        return [RVFakeUrlSession new];
    }
    return [NSURLSession sharedSession];
}

+(BOOL) isRunningUnitTests
{
    if(disable_testing) return NO;
    
    NSDictionary* environment = [ [ NSProcessInfo processInfo ] environment ];
    NSString* theTestConfigPath = environment[ @"XCTestConfigurationFilePath" ];
    return theTestConfigPath != nil;
}

+(void)disableTest{
    disable_testing = true;
}

+(void)enableTest{
    disable_testing = false;
}

@end
