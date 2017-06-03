//
//  NetworkServiceSessionManager.m
//  NetworkLayer
//
//  Created by Haider, Wali (Contractor) on 06/01/2017.
//  Copyright (c) 2017 Haider, Wali (Contractor). All rights reserved.
//

#import "NetworkServiceSessionManager.h"
#import "NetworkAPIStringUtility.h"
#import "NetworkQueryComposer.h"
@implementation NetworkServiceSessionManager


+ (NSURLSessionDataTask *)getPinBoardInfoWithCompletion:(void (^)(NSArray *, NSError *))callBack
{
    NSString *baseUrl = [NSString stringWithFormat:@"%@%@",[NetworkAPIStringUtility baseUrl],[NetworkQueryComposer getPinBoardDetailsApiURL]];
    
    NSURLRequest * request = [self createGetRequestWithBaseUrl:baseUrl andParamString:@""];
    
    NSURLSessionDataTask *sessionTask = [self dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                         {
                                             if ( error )
                                             {
                                                 NSLog(@"error : %@", error);
                                                 callBack(nil, error);
                                             }
                                             else
                                             {
                                                 NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                 
                                                 
                                                 callBack(array, nil);
                                             }
                                         }];
    return sessionTask;

}
+ (NSMutableURLRequest *)createPostRequestWithBaseUrl:(NSString *)baseUrl andParamDict:(NSDictionary *)dict {
    
    NSData *jsonData = nil;
    NSError *error;
    if(dict)
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        NSString *jsonBody = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        NSLog(@"POST urlString : %@ \njson data for api: %@", baseUrl, jsonBody);
    }
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseUrl]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:4060];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if(jsonData)
        [request setHTTPBody:jsonData];
    
    return [request mutableCopy];
}

+ (NSMutableURLRequest *)createGetRequestWithBaseUrl:(NSString *)baseUrl andParamString:(NSString *)paramString
{
    NSLog(@"GET urlString : %@?%@", baseUrl, paramString);
    
    NSString *urlString = paramString.length > 0 ? [NSString stringWithFormat:@"%@?%@", baseUrl, paramString] : [NSString stringWithFormat:@"%@", baseUrl];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:60];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return [request mutableCopy];
}

+ (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSDictionary * dictionaryResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            if(dictionaryResponse)
            {
                NSLog(@"API is: %@ \n and Response is: \n %@",[request URL],
                      [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dictionaryResponse
                                                                                     options:NSJSONWritingPrettyPrinted
                                                                                       error:nil]
                                            encoding:NSUTF8StringEncoding]);
            }
        }
        
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode]==401) {
            NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sessionError" object:self];
        }
        else{
            
            completionHandler(data, response, error);
        }
        
    }];
    return dataTask;
}

@end
