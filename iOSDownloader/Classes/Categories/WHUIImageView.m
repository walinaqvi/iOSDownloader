//
//  WHUIImageView.m
//  Pods
//
//  Created by Haider, Wali (Contractor) on 6/3/17.
//
//

#import "WHUIImageView.h"
#import "WHDownloadManager.h"
@interface WHUIImageView()
/**
 Property that holds the refrence of operation which is downloading image
 */
@property(strong,nonatomic)WHBlockOperationWithUrl *operation;

@end

@implementation WHUIImageView

#pragma mark - PublicMathodsImplementation
- (void)setImageFromUrl:(NSString*)url withActivityIndicator:(BOOL)activityIndicatorEnabled
{
    self.operation = [[WHDownloadManager sharedManager] setImageFromUrl:url toImageView:self withActivityIndicatorEnable:activityIndicatorEnabled];
    
}
- (BOOL)cancelDownloadTask
{
    if (!self.operation || self.operation.isCancelled) {
        return NO;
    }else
    {
        [self.operation cancel];
        return YES;
    }
}

@end
