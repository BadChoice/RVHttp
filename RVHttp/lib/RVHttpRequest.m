//
//  RVHttpRequest.m
//  RVUtils
//
//  Created by Jordi Puigdellívol on 2/3/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import "RVHttpRequest.h"
#import "RVCollection.h"

@implementation RVHttpRequest

+(RVHttpRequest*)method:(NSString*)method url:(NSString*)url{
    return [self.class method:method url:url params:nil headers:nil];
}

+(RVHttpRequest*)method:(NSString*)method url:(NSString*)url params:(NSDictionary*)params{
    return [self.class method:method url:url params:params headers:nil];
}

+(RVHttpRequest*)method:(NSString*)method url:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers{
    RVHttpRequest* request   = [RVHttpRequest new];
    request.url                 = url;
    request.method              = method;
    request.parameters          = params;
    request.headers             = headers;
    return request;
}

-(NSMutableURLRequest*)generate{
    
    if( ! [@[@"GET",@"POST",@"PUT",@"PATCH",@"DELETE"] containsObject:self.method] ){
        [NSException raise:@"Invalid Method" format:@"%@ is not a valid HTTP Verb", self.method];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:self.method];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    if(self.timeout != 0){
        request.timeoutInterval = self.timeout;
    }
    
    if( isEqual(@"GET", self.method) ){
        NSString* url = [self buildUrl];
        [request setURL:[NSURL URLWithString:url]];
        DLog(@"Url: %@", url);
    }
    else{
        NSString* body = isNull(self.body) ? [self buildBody:NO] : self.body;
        [request setURL:[NSURL URLWithString:self.url]];
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        DLog(@"Url: %@", self.url);
        DLog(@"Body: %@", body.urlDecode);
    }
    [self addHeaders:request];
    
    return request;
}

-(void)addHeaders:(NSMutableURLRequest*)request{
    if( isNull(self.headers) ) return;
    [self.headers each:^(id key, id object) {
        [request setValue:object forHTTPHeaderField:key];
    }];
}

-(NSString*)buildBody:(BOOL)paramEncoded{
    return [self.parameters.allKeys reduce:^id(NSString* carry, NSString* paramKey) {
        if( isNull(self.parameters[paramKey]) ) return str(@"%@%@&", carry, paramKey);
        
        NSString* param = self.parameters[paramKey];
        if(paramEncoded && [param isKindOfClass:NSString.class]){
            param = param.urlEncode;
        }
        
        return str(@"%@%@=%@&", carry, paramKey, param);
    } carry:@""];
}

-(NSString*)buildUrl{
    if(self.parameters && self.parameters.count > 0){
        NSString * body = [self buildBody:YES];
        return str(@"%@?%@",self.url, body);
    }
    return self.url;
}

-(NSString*)toString{
    return @{
             @"url"        : valueOrNull ( self.url ),
             @"method"     : valueOrNull ( self.method ),
             @"body"       : valueOrNull ( self.body ),
             @"parameters" : valueOrNull ( self.parameters ),
             @"headers"    : valueOrNull ( self.headers )
             }.toString;
}

+(RVHttpRequest*)fromStringDict:(NSString*)stringDict{
    NSDictionary* dict          = [NSDictionary fromString:stringDict];
    RVHttpRequest* request   = [RVHttpRequest method:dict[@"method"] url:dict[@"url"]];
    request.parameters          = dict[@"parameters"];
    request.headers             = dict[@"headers"];
    request.body                = dict[@"body"];
    return request;
}

@end
