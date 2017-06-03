//
//  WHUIImageView.h
//  Pods
//
//  Created by Haider, Wali (Contractor) on 6/3/17.
//
//

#import <UIKit/UIKit.h>
#import "WHBlockOperationWithUrl.h"
/**
 * Integrates WHUIImageView async downloading and caching of remote images with UIImageView.
 *
 * Usage with a UITableViewCell sub-class:
 *
 * @code
 
 #import "WHUIImageView.h"
 
 ...
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *MyIdentifier = @"MyIdentifier";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
 
 if (cell == nil) {
 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier]
 autorelease];
 }
 
 // Here we use the provided setImageFromUrl: method to load the web image
 // Ensure you use a placeholder image otherwise cells will be initialized with no image
 [cell.imageView setImageFromUrl:@"http://example.com/image.jpg" withActivityIndicator:YES];
 
 
 cell.textLabel.text = @"My Text";
 return cell;
 }
 
 * @endcode
 */
@interface WHUIImageView : UIImageView

/**
 Public mathod that set remote image to a UIimageView

 @param url remote image URL
 @param activityIndicatorEnabled flag to show activity indicator on UIImageView
 */
- (void)setImageFromUrl:(NSString*)url withActivityIndicator:(BOOL)activityIndicatorEnabled;

/**
 Public mathod to cancel download task for UIimageView

 @return YES if task is cancelled returns NO if task does not exist or already cancelled
 */
- (BOOL)cancelDownloadTask;

@end
