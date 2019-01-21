#import <Foundation/Foundation.h>

@interface RVHttpFake : NSObject
+ (void)enable;
+ (void)disable;
+ (void)setResponse:(NSDictionary *)json;
+ (void)setResponse:(NSDictionary*)json withStatusCode:(int)statusCode;
+ (void)setResponseFor:(NSString *)url response:(NSDictionary *)json;

+ (void)setResponses:(NSArray *)array;
@end
