//
//  NetworkAPIStringUtility.h
//  NetworkLayer
//
//  Created by Haider, Wali (Contractor) on 06/01/2017.
//  Copyright (c) 2017 Haider, Wali (Contractor). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkAPIStringUtility : NSObject


/**
 Mathod to get base URL of API Requests

 @return Base URL
 */
+ (NSString*)baseUrl;

/**
 Mathod to get base URL of API request for perticular client Version

 @param version Client API version
 @return Base URL
 */
+ (NSString*) baseUrlWithVersion:(NSInteger)version;


@end
