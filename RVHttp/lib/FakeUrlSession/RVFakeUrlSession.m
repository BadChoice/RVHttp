//
//  RVFakeUrlSession.m
//  RVUtils
//
//  Created by Jordi Puigdellívol on 15/12/16.
//  Copyright © 2016 Revo. All rights reserved.
//

#import "RVFakeUrlSession.h"
#import "RVFakeUrlSessionDataTask.h"

@implementation RVFakeUrlSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(nonnull void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler{
    
    return [RVFakeUrlSessionDataTask make:request completion:completionHandler];
}

@end
