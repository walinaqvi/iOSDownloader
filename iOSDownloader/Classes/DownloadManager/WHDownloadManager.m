//
//  WHDownloadManager.m
//  Pods
//
//  Created by Haider, Wali (Contractor) on 6/2/17.
//
//

#import "WHDownloadManager.h"

/**
 Custome cache class to clean cache on memory warning
 */
@interface WHCache : NSCache
@end

@implementation WHCache

- (id)init
{
    self = [super init];
    if (self) {
        
        //Add memory warning observer to clean cache
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}
- (void)dealloc
{
    //Remove notification observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
}

@end

@interface WHDownloadManager()
@property(strong,nonatomic)WHCache *mainMemoryCache;
@property (nonatomic, strong) NSOperationQueue *downloadOperationQueue;

@end
@implementation WHDownloadManager
#pragma mark - Singleton
+ (WHDownloadManager *)sharedManager {
    static dispatch_once_t once;
    static WHDownloadManager *instance;
    dispatch_once(&once, ^{
        instance = [self new];
        //Initialize queue and cache
        instance.downloadOperationQueue = [[NSOperationQueue alloc]init];
        instance.downloadOperationQueue.maxConcurrentOperationCount = 5;
        instance.mainMemoryCache = [[WHCache alloc] init];
        
    });
    return instance;
}

#pragma mark - PublicMathodImplementation
- (WHBlockOperationWithUrl*)setImageFromUrl:(NSString*)urlString toImageView:(UIImageView*)imageView withActivityIndicatorEnable:(BOOL)activityIndicatorEnable
{
    //Clear existing image on UIimageView
    imageView.image = nil;
    WHBlockOperationWithUrl *operation;
  
    //Add activity indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (activityIndicatorEnable) {
        [self addActivityView:activityIndicator toCenterOfImageView:imageView];
    }
    
    //Create a file name space for key of cache
    NSString *fileNamespace = [@"com.WH.DownloadManager." stringByAppendingString:urlString];
    
    //Get image from cache for filenamespace
    UIImage *imageFromCache = [self.mainMemoryCache objectForKey:fileNamespace];
    if (imageFromCache) {
        imageView.image = imageFromCache;
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
    }else
    {
        //Load image from remote
        NSArray *operations =[_downloadOperationQueue operations];
        NSArray *duplicateTasks = [operations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(url == %@)", urlString]];
       
        //Create a weak refrence to avoid retain cycle in block
        __weak typeof(self) weakSelf = self;
        //if this is not first operation
        if (operations.count>0) {
            //Check for duplicate data
            if (duplicateTasks.count>0) {
                NSLog(@"Handel duplicate operation here: <%@:%@:%d>",NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
            }
            else {
                //If not duplicate data then create an operation
                operation = [WHBlockOperationWithUrl blockOperationWithBlock:^{
                    //Download image
                    UIImage *downloadedImage = [self getImageFromURL:urlString];
                    //Dispatch main Queue to update UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (downloadedImage != nil) {
                            // update cache
                            [weakSelf.mainMemoryCache setObject:downloadedImage forKey:fileNamespace];
                            //Update ImageView
                            imageView.image = downloadedImage;
                        }else
                        {
                            //We can add placeholder image/Text here
                            imageView.image = nil;
                        }
                        [activityIndicator stopAnimating];
                        [activityIndicator removeFromSuperview];
                    });
                    
                    
                    
                }];
                //Add operation to queue
                [_downloadOperationQueue addOperation:operation];
            }
        }else
        {
            //Create first operation
            operation = [WHBlockOperationWithUrl blockOperationWithBlock:^{
                //Download image
                UIImage *downloadedImage = [weakSelf getImageFromURL:urlString];
                
                //Dispatch main Queue to update UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (downloadedImage != nil) {
                        // update cache
                        [weakSelf.mainMemoryCache setObject:downloadedImage forKey:fileNamespace];
                        //Update ImageView
                        imageView.image = downloadedImage;
                    }else
                    {
                        //We can add placeholder image/Text here
                        imageView.image = nil;
                    }
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                });
                
                
                
            }];
            //Add operation to queue
            [_downloadOperationQueue addOperation:operation];
        }
        
    }
    return operation;
    
}

#pragma mark - PrivateMathod
- (void)addActivityView:(UIActivityIndicatorView*)activityIndicator toCenterOfImageView:(UIImageView*)imageView
{
    [activityIndicator setCenter: imageView.center];
    [activityIndicator startAnimating];
    //Add central alignment constraints
    [imageView addSubview:activityIndicator];
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView addSubview:activityIndicator];
    [activityIndicator addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:100]];
    [activityIndicator addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:200]];
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
@end
