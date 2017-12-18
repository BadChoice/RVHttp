#import <Foundation/Foundation.h>

@interface RVHttpFake : NSObject
+ (void)enable;
+ (void)disable;
+ (void)setResponse:(NSDictionary *)json;
+ (void)setResponseFor:(NSString *)url response:(NSDictionary *)json;
@end