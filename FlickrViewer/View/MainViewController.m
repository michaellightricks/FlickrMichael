// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "MainViewController.h"

#import "ImageDataProvider.h"
#import "NSURLSessionTasksFactory.h"
#import "PhotoRecord.h"
#import "PhotosSourceFlickr.h"
#import "PlaceRecord.h"
#import "PlacesSourceFlickr.h"
#import "ScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController ()

/// Protocol to perform the network tasks with.
@property (strong, nonatomic) id<NetworkTasksFactory> tasksFactory;

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
  PlacesSourceFlickr *placesSource =
      [[PlacesSourceFlickr alloc] initWithTasksFactory:self.tasksFactory];
  
  [placesSource requestPlaceRecordsWithMaxCount:1
                                     completion:^(NSArray<PlaceRecord *> * _Nullable placeRecords,
                                                  id<CancelTokenProtocol> token) {
    if (!placeRecords.count) {
      [token cancelWithError:[self.tasksFactory
          errorWithMessage:@"No place records was loaded."]];
    }
    if (token.cancelled) {
      [self handleError:token.error message:@"Error occured during place records request."];
      return;
    }
   
    // Getting first photo for the first top place.
    PlaceRecord *topPlace = placeRecords[0];
   
    PhotosSourceFlickrByPlace *photoSource =
        [[PhotosSourceFlickrByPlace alloc] initWithPlaceID:topPlace.placeID
                                              tasksFactory:self.tasksFactory];
   
    [photoSource requestPhotoRecordsWithMaxCount:1
                                      completion:^(NSArray<PhotoRecord *> * _Nullable photoRecords,
                                                   id<CancelTokenProtocol> token) {
      if (!photoRecords.count) {
        [token cancelWithError:[self.tasksFactory
            errorWithMessage:@"No photo records was loaded."]];
      }
                                        
      if (token.cancelled) {
        [self handleError:token.error message:@"Error occured during photo records request."];
        return;
      }
    
      PhotoRecord *topPhoto = photoRecords[0];
     
      [self showPhotoFromURL:topPhoto.url title:topPhoto.title];
    }];
  }];
}

- (void)showPhotoFromURL:(NSURL *)url title:(NSString *)title{
  // Photo downloading is handled by scrollview controller so redirecting the request there.
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.scrollViewController.view removeFromSuperview];
    [self.scrollViewController removeFromParentViewController];
    
    ImageDataProvider *provider =
        [[ImageDataProvider alloc] initWithTasksFactory:self.tasksFactory];
    
    self.scrollViewController =
    [[ScrollViewController alloc] initWithUrl:url title:title provider:provider];

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

- (id<NetworkTasksFactory>)tasksFactory {
  if (!_tasksFactory) {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    _tasksFactory = [[NSURLSessionTasksFactory alloc] initWithSession:session];
  }
  
  return _tasksFactory;
}

@end

NS_ASSUME_NONNULL_END
