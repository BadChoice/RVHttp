//
//  RVFakeUrlSessionDataTask.m
//  RVUtils
//
//  Created by Jordi Puigdellívol on 15/12/16.
//  Copyright © 2016 Revo. All rights reserved.
//

#import "RVFakeUrlSessionDataTask.h"

@implementation RVFakeUrlSessionDataTask

static NSMutableDictionary* responses;

+(RVFakeUrlSessionDataTask*)make:(NSURLRequest*)request completion:(void (^)(NSData* data, NSURLResponse* response, NSError* error))completion{
    RVFakeUrlSessionDataTask* fakeSessionDataTask   = [RVFakeUrlSessionDataTask new];
    fakeSessionDataTask.request                     = request;
    fakeSessionDataTask.completion                  = completion;
    return fakeSessionDataTask;
}

-(void)resume{
    NSDictionary* response = responses[self.request.URL.absoluteString];
    if( ! response ){
        return self.completion(nil, nil, [self noRequestError]);
    }
    NSData* data = [NSJSONSerialization dataWithJSONObject:response
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    self.completion(data,nil,nil);
}

+(void)addResponseForUrl:(NSString*)url response:(NSDictionary*)json{
    if( ! responses) responses  = [NSMutableDictionary new];
    responses[url]              = json;
}

-(NSError*)noRequestError{
    
    return [[NSError alloc] initWithDomain:@"RVNetwork"
                                      code:1
                                  userInfo:@{
                                      NSLocalizedFailureReasonErrorKey:@"No test request defined",
                                      NSLocalizedDescriptionKey:@"NoTestRequest",
                                      NSLocalizedRecoverySuggestionErrorKey:@"Implement the request in the [RVFakeUrlSessionDataTask addResponseForUrl]",
                                    }];
}


@end
