# RVHttp 
 
#### Super easy HTTP

```
[RVHttp get:@"https://httpbin.org/get" params:@{@"name" : @"Jordi"} headers:@{@"Custom-Header": @"header-value"} completion:^(RVHttpResponse *response) {

    NSDictionary* responseDict = response.toDictionary;
    
    }];
```
