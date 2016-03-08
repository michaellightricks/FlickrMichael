// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "MainViewController.h"

#import "ImageDataProvider.h"
#import "NSURLSessionHelper.h"
#import "PhotoRecord.h"
#import "PhotosSourceFlickr.h"
#import "PlaceRecord.h"
#import "PlacesSourceFlickr.h"
#import "ScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController ()

/// URL session to perform the network operations on.
@property (strong, nonatomic) NSURLSession *session;

/// Scroll view controller that loads and presents the image.
@property (strong, nonatomic) ScrollViewController *scrollViewController;

/// Activity indicator to show the downaload process.
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

/// Placeholder for active view (activity indicator or scrollView
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.activityIndicator.hidesWhenStopped = YES;
  [self.activityIndicator startAnimating];
  
  // Since all requests are cancellable async operations with completionswe will chain them
  // together using completion blocks.
  
  // First getting Flickr top places.
  PlacesSourceFlickr *placesSource = [[PlacesSourceFlickr alloc] initWithURLSession:self.session];
  
  [placesSource requestPlaceRecordsWithMaxCount:1
                                     completion:^(NSArray<PlaceRecord *> * _Nullable placeRecords,
                                                  NSError * _Nullable error) {
    if (error || !placeRecords.count) {
      [self handleError:error message:@"Error occured during place records request."];
      return;
    }
   
    // Getting first photo for the first top place.
    PlaceRecord *topPlace = placeRecords[0];
   
    PhotosSourceFlickrByPlace *photoSource =
        [[PhotosSourceFlickrByPlace alloc] initWithPlaceID:topPlace.placeID
                                                   session:self.session];
   
    [photoSource requestPhotoRecordsWithMaxCount:1
                                      completion:^(NSArray<PhotoRecord *> * _Nullable photoRecords,
                                                   NSError * _Nullable error) {
      if (!photoRecords.count) {
        error = [NSURLSessionHelper createErrorWithMessage:@"No photo records was loaded."];
      }
                                        
      if (error) {
        [self handleError:error message:@"Error occured during photo records request."];
        return;
      }
    
      PhotoRecord *topPhoto = photoRecords[0];
     
      [self showPhotoFromURL:topPhoto.url];
    }];
  }];
}

- (void)showPhotoFromURL:(NSURL *)url {
  // Photo downloading is handled by scrollview controller so redirecting the request there.
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.scrollViewController.view removeFromSuperview];
    [self.scrollViewController removeFromParentViewController];
    
    ImageDataProvider *provider = [[ImageDataProvider alloc] initWithURLSession:self.session];
    
    self.scrollViewController =
        [[ScrollViewController alloc] initWithUrl:url provider:provider];

    [self addChildViewController:self.scrollViewController];
    self.scrollViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:self.scrollViewController.view];
    [self.scrollViewController didMoveToParentViewController:self];
    [self.activityIndicator stopAnimating];
  });
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  self.scrollViewController.view.frame = self.containerView.bounds;
}

- (void)handleError:(NSError *)error message:(NSString *)message   {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self stopActivityIndicatorSafe];
    NSLog(@"%@\n%@", message, error.description);
  });
}

- (void)stopActivityIndicatorSafe {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.activityIndicator stopAnimating];
  });
}

- (NSURLSession *)session {
  if (!_session) {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config];
  }
  
  return _session;
}

@end

NS_ASSUME_NONNULL_END
