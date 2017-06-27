//
//  RVHttpResponse.m
//  RVUtils
//
//  Created by Eduard Duocastella Altimira on 3/5/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import "RVHttpResponse.h"
#import "RVCollection.h"

@implementation RVHttpResponse

-(id) initWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    
    if (self = [super init]) {
        self.data           = data;
        self.response       = response;
        self.error          = error;
    }

    return self;
}

-(NSInteger) statusCode {
    return ((NSHTTPURLResponse*)self.response).statusCode;
}

-(NSString*) errorMessage {
    if (!self.error)
        return nil;
    
    return self.error.localizedDescription;
}

-(NSString*) toString {
    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

-(NSDictionary*) toDictionary {
    return [NSDictionary fromData:self.data];
}

-(UIImage*) toImage {
    return [UIImage imageWithData:self.data];
}

@end
