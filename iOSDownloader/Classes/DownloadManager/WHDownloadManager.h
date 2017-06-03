//
//  WHDownloadManager.h
//  Pods
//
//  Created by Haider, Wali (Contractor) on 6/2/17.
//
//

#import <Foundation/Foundation.h>
#import "WHDownloadManager.h"
#import <UIKit/UIKit.h>
#import "WHBlockOperationWithUrl.h"

@interface WHDownloadManager : NSObject

/**
 Sindleton to get shared instance

 @return Shared instance of WHDownloadManager
 */
+ (WHDownloadManager *)sharedManager;

/**
 Mathod to set image to a UIImageView
 @param urlString URL of image source
 @param imageView UIImageView to which image need to set
 @param activityIndicatorEnable Flag to show activity indicator on UIImageView
 @return Block operation refrence for further use
 */
- (WHBlockOperationWithUrl*)setImageFromUrl:(NSString*)urlString toImageView:(UIImageView*)imageView withActivityIndicatorEnable:(BOOL)activityIndicatorEnable;
@end
