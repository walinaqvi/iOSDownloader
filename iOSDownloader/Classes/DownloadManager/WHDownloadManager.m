//
//  WHDownloadManager.m
//  Pods
//
//  Created by Haider, Wali (Contractor) on 6/2/17.
//
//

#import "WHDownloadManager.h"
#import "WHBlockOperationWithUrl.h"
@interface WHCache : NSCache
@end

@implementation WHCache

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
}

@end
@interface WHDownloadManager()
@property(strong,nonatomic)WHCache *mainMemoryCache;
@property (nonatomic, strong) NSOperationQueue *downloadOperationQueue;

@end
@implementation WHDownloadManager
+ (WHDownloadManager *)sharedManager {
    static dispatch_once_t once;
    static WHDownloadManager *instance;
    dispatch_once(&once, ^{
        instance = [self new];
        instance.downloadOperationQueue = [[NSOperationQueue alloc]init];
        instance.downloadOperationQueue.maxConcurrentOperationCount = 5;
        instance.mainMemoryCache = [[WHCache alloc] init];

    });
    return instance;
}

- (void)setImageFromUrl:(NSString*)urlString toImageView:(UIImageView*)imageView withActivityIndicatorEnable:(BOOL)activityIndicatorEnable
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (activityIndicatorEnable) {
        [activityIndicator setCenter: imageView.center];
        [activityIndicator startAnimating];
        [imageView addSubview:activityIndicator];

    }
    NSString *fileNamespace = [@"com.WH.DownloadManager." stringByAppendingString:urlString];

    UIImage *imageFromCache = [self.mainMemoryCache objectForKey:fileNamespace];
    if (imageFromCache) {
        imageView.image = imageFromCache;
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }else
    {
        NSArray *operations =[_downloadOperationQueue operations];
        
        if (operations.count>0) {
            for(WHBlockOperationWithUrl *op in [_downloadOperationQueue operations])
                if (op.url == urlString) {
                    NSLog(@"Operation is in the queue");
                }
                else {
                    WHBlockOperationWithUrl *op = [WHBlockOperationWithUrl blockOperationWithBlock:^{
                        UIImage *downloadedImage = [self getImageFromURL:urlString];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (downloadedImage != nil) {
                                
                                // update cache
                                [self.mainMemoryCache setObject:downloadedImage forKey:fileNamespace];
                                imageView.image = downloadedImage;
                            }
                            [activityIndicator stopAnimating];
                            [activityIndicator removeFromSuperview];
                        });
                        
                        
                        
                    }];
                    [_downloadOperationQueue addOperation:op];
                }
        }else
        {
            WHBlockOperationWithUrl *op = [WHBlockOperationWithUrl blockOperationWithBlock:^{
                UIImage *downloadedImage = [self getImageFromURL:urlString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (downloadedImage != nil) {
                        
                        // update cache
                        [self.mainMemoryCache setObject:downloadedImage forKey:fileNamespace];
                        imageView.image = downloadedImage;
                    }
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                });
                
                
                
            }];
            [_downloadOperationQueue addOperation:op];
 
        }
        
    }

}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
@end
