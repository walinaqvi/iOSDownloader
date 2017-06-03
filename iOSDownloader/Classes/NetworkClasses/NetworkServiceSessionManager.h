//
//  NetworkServiceSessionManager.h
//  NetworkLayer
//
//  Created by Haider, Wali (Contractor) on 06/01/2017.
//  Copyright (c) 2017 Haider, Wali (Contractor). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkServiceSessionManager : NSObject
#pragma mark - API mathods 
/**
 Mathod to get pinBoard informations
 
 @param callBack a completion handeler Block
 @return  a task to be resume
 */
+ (NSURLSessionDataTask *)getPinBoardInfoWithCompletion:(void (^)(NSArray *, NSError *))callBack;


@end
