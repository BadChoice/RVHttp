//
//  RVNetworkResponse.h
//  RVUtils
//
//  Created by Eduard Duocastella Altimira on 3/5/17.
//  Copyright © 2017 Revo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RVHttpResponse : NSObject

@property (strong,nonatomic) NSData         *data;
@property (strong,nonatomic) NSURLResponse  *response;
@property (strong,nonatomic) NSError        *error;

-(id) initWithData:(NSData*) data response:(NSURLResponse*) response error:(NSError*) error;

-(NSInteger) statusCode;
-(NSString*) errorMessage;
-(NSDictionary*) toDictionary;
-(NSString*) toString;
-(UIImage*) toImage;

@end
