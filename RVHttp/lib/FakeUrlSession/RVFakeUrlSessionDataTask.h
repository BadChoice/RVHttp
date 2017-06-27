//
//  RVFakeUrlSessionDataTask.h
//  RVUtils
//
//  Created by Jordi Puigdellívol on 15/12/16.
//  Copyright © 2016 Revo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RVFakeUrlSessionDataTask : NSURLSessionDataTask

@property (strong,nonatomic) NSURLRequest * request;
@property (nonatomic, copy) void (^completion)(NSData* data, NSURLResponse* response, NSError* error);


+(RVFakeUrlSessionDataTask*)make:(NSURLRequest*)request completion:(void (^)(NSData* data, NSURLResponse* response, NSError* error))completion;

+(void)addResponseForUrl:(NSString*)url response:(NSDictionary*)json;

@end
