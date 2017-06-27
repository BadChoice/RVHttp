//
//  RVNetworkRequest.h
//  RVUtils
//
//  Created by Jordi Puigdellívol on 2/3/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RVHttpRequest : NSObject


@property(strong,nonatomic) NSString* url;
@property(strong,nonatomic) NSString* method;
@property(strong,nonatomic) NSString* body;
@property(strong,nonatomic) NSDictionary* parameters;
@property(strong,nonatomic) NSDictionary* headers;

+(RVHttpRequest*)method:(NSString*)method url:(NSString*)url;
+(RVHttpRequest*)method:(NSString*)method url:(NSString*)url params:(NSDictionary*)params;
+(RVHttpRequest*)method:(NSString*)method url:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers;
+(RVHttpRequest*)fromStringDict:(NSString*)stringDict;

-(NSMutableURLRequest*)generate;
-(NSString*)toString;
@end
