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

@interface WHDownloadManager : NSObject

+ (WHDownloadManager *)sharedManager;
- (void)setImageFromUrl:(NSString*)urlString toImageView:(UIImageView*)imageView withActivityIndicatorEnable:(BOOL)activityIndicatorEnable;
@end
