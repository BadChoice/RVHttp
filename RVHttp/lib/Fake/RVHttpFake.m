#import "RVHttpFake.h"
#import "RVHttpRequest.h"
#import "RVHttpResponse.h"
#import "RVHttp.h"
#import "RVCollection.h"
#import <objc/runtime.h>

@implementation RVHttpFake

static NSMutableDictionary* responses;
static id globalResponse;
static int globalResponseStatuscode;
static bool swizzled;

+(void)enable{
    if(swizzled) return;
    SEL originalSelector = @selector(call:completion:);
    SEL newSelector      = @selector(callFake:completion:);

    Class c = object_getClass((id)RVHttp.class);
    Class c2 = object_getClass((id)RVHttpFake.class);

    Method originalMethod = class_getInstanceMethod(c, originalSelector);
    Method newMethod = class_getInstanceMethod(c2, newSelector);

    BOOL didAddMethod = class_addMethod(c, originalSelector,
                    method_getImplementation(newMethod),
                    method_getTypeEncoding(newMethod));

    if (didAddMethod) {
        class_replaceMethod(c, newSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod));
    }
    else
        method_exchangeImplementations(originalMethod, newMethod);

    swizzled = true;
}

+(void)disable{
    if(!swizzled) return;
    swizzled = false;
    [self.class enable];
    swizzled = false;
}

+(void)callFake:(RVHttpRequest*)theRequest completion:(void (^)(RVHttpResponse *response))completion{
    if (responses[theRequest.url]) {
        return [RVHttpFake.class respond:responses[theRequest.url] completion:completion];
    }

    if (globalResponse) {
        if ([globalResponse isKindOfClass:NSArray.class]){
            return [RVHttpFake.class respond:((NSArray*)globalResponse).pop completion:completion];
        }
        return [RVHttpFake.class respond:globalResponse completion:completion];
    }
    completion(nil);
}

+ (void)respond:(id)response completion:(void (^)(RVHttpResponse *))completion {
    if ([response isKindOfClass:RVHttpResponse.class]) {
        return completion(response);
    }
    NSDictionary* responseDict = response;
    NSHTTPURLResponse * r = [[NSHTTPURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:@"http://fakeurl.com"] statusCode:(globalResponseStatuscode ? globalResponseStatuscode : 200) HTTPVersion:@"1.0" headerFields:nil];
    RVHttpResponse * httpResponse = [[RVHttpResponse alloc] initWithData:[NSData dataWithBytes:responseDict.toString.UTF8String length:responseDict.toString.length] response:r error:nil];
    return completion(httpResponse);
}

+ (void)setResponse:(NSDictionary*)json withStatusCode:(int)statusCode{
    globalResponse = json;
    globalResponseStatuscode = statusCode;
}

+(void)setResponse:(NSDictionary*)json{
    [self.class setResponse:json withStatusCode:200];
}

+(void)setResponseFor:(NSString *)url response:(NSDictionary*)json{
    if( ! responses) responses  = [NSMutableDictionary new];
    responses[url]              = json;
}

+ (void)setResponses:(NSArray *)array {
    globalResponse = array.mutableCopy;
    globalResponseStatuscode = 200;
}
@end
