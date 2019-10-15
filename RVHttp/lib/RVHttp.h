#import <Foundation/Foundation.h>
#import "RVHttpRequest.h"
#import "RVHttpResponse.h"

@interface RVHttp : NSObject


+(void)post:(NSString*)url params:(NSDictionary*)params completion:(void (^)(RVHttpResponse *response))completion;

+(void)post:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion;

+(void)put:(NSString*)url params:(NSDictionary*)params completion:(void (^)(RVHttpResponse *response))completion;

+(void)put:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion;

+(void)delete:(NSString*)url completion:(void (^)(RVHttpResponse* response))completion;

+(void)delete:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion;

+(void)post:(NSString*)url body:(NSString*)body completion:(void (^)(RVHttpResponse *response))completion;

+(void)postJson:(NSString*)url body:(NSString*)body completion:(void (^)(RVHttpResponse* response))completion;

+(void)post:(NSString*)url body:(NSString*)body headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse *response))completion;

+(void)get:(NSString*)url params:(NSDictionary*)params completion:(void (^)(RVHttpResponse *response))completion;

+(void)get:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers completion:(void (^)(RVHttpResponse* response))completion;

+(void)call:(RVHttpRequest*)theRequest completion:(void (^)(RVHttpResponse* response))completion;

+(void)setUrlSession:(NSURLSession *)newSession;

+ (NSURLSession *)getUrlSession;
+ (void)disableTest;
+ (void)enableTest;
+ (void)enableDebug;
+ (void)disableDebug;
@end
