//
//  NetworkAPIStringUtility.m
//  NetworkLayer
//
//  Created by Haider, Wali (Contractor) on 06/01/2017.
//  Copyright (c) 2017 Haider, Wali (Contractor). All rights reserved.
//

#import "NetworkAPIStringUtility.h"

@implementation NetworkAPIStringUtility
NSString *baseUrl = @"http://pastebin.com/";

#pragma mark - Base Url

+ (void) setBaseUrl:(NSString *)url {
    baseUrl = url;
}

+ (NSString*) baseUrl {
    return baseUrl;
}




@end
