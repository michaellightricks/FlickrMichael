// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PhotosTableViewController.h"

#import "ImageDataProvider.h"
#import "PhotosViewModelAdapter.h"
#import "ProtocolsFactory.h"
#import "ScrollViewController.h"
#import "TableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotosTableViewController()

/// Used to extract photo's properties for table view model.
@property (strong, nonatomic) PhotosViewModelAdapter *adapter;

@end

@implementation PhotosTableViewController

static NSString * const kPhotoSegueString = @"ShowPhoto";

static const NSUInteger kPhotosRecordsMaxCount = 100;

- (id<CancelTokenProtocol>)loadDataWithCompletion:(ReloadDataCompletionBlockType)completion {
  id<CancelTokenProtocol> token =
      [self.photosSource requestPhotoRecordsWithMaxCount:kPhotosRecordsMaxCount
                                              completion:completion];
  
  return token;
}

- (void)setPhotosSource:(id<PhotosSourceProtocol>)photosSource {
  _photosSource = photosSource;
  
  self.viewModel = [[TableViewModel alloc] initWithAdapter:self.adapter delegate:self];
}

- (void)rowSelected:(id)row {
  [self performSegueWithIdentifier:kPhotoSegueString sender:row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if ([segue.identifier isEqualToString:kPhotoSegueString]) {
    PhotoRecord *record = (PhotoRecord *)sender;
    
    UINavigationController *targetViewController =
        (UINavigationController *)segue.destinationViewController;
    [self.presenter showPhoto:record inNavigationController:targetViewController];
  }
}

- (PhotosViewModelAdapter *)adapter {
  if (!_adapter) {
    _adapter = [[PhotosViewModelAdapter alloc] init];
  }
  
  return _adapter;
}

@end

NS_ASSUME_NONNULL_END
