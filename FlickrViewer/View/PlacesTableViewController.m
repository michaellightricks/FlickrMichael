// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PlacesTableViewController.h"

#import "PhotosSourceFlickr.h"
#import "PhotosTableViewController.h"
#import "PlacesSourceFlickr.h"
#import "PlacesViewModelAdapter.h"
#import "Protocols.h"
#import "ProtocolsFactory.h"
#import "TableViewController.h"
#import "TableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlacesTableViewController()

/// Source for Flickr places.
@property PlacesSourceFlickr *placesSource;

/// Place that was last selected by user.
@property (strong, nonatomic) PlaceRecord *selectedPlace;

/// Adapter to extract place's properties for table view model.
@property (strong, nonatomic) PlacesViewModelAdapter *adapter;

/// Protocol to perform the network tasks with.
@property (strong, nonatomic) id<NetworkTasksFactory> tasksFactory;

@end

@implementation PlacesTableViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  if (!self.placesSource) {
    self.placesSource = [[PlacesSourceFlickr alloc] initWithTasksFactory:self.tasksFactory];
    self.viewModel = [[TableViewModel alloc] initWithAdapter:self.adapter delegate:self];
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
  if ([segue.identifier isEqualToString:@"ShowPhotosTable"]) {
    PhotosTableViewController *targetViewController =
        (PhotosTableViewController *)segue.destinationViewController;

    targetViewController.photosSource =
        [[PhotosSourceFlickrByPlace alloc] initWithPlaceID:self.selectedPlace.placeID
                                              tasksFactory:[ProtocolsFactory networkProtocol]];
    targetViewController.presenter =
        [[PhotoPresenter alloc] initWithImageProvider:[ProtocolsFactory createImageProvider]
                                              history:[ProtocolsFactory historyProtocol]];
  }
}

static const NSUInteger kPlacesRecordsMaxCount = 100;

- (id<CancelTokenProtocol>)loadDataWithCompletion:(ReloadDataCompletionBlockType)completion {
  id<CancelTokenProtocol> token =
      [self.placesSource requestPlaceRecordsWithMaxCount:kPlacesRecordsMaxCount
                                              completion:completion];
  return token;
}

static NSString * const kShowPhotosTableSegue = @"ShowPhotosTable";

- (void)rowSelected:(id)row {
  PlaceRecord *record = (PlaceRecord *)row;
  self.selectedPlace = record;
  
  [self performSegueWithIdentifier:kShowPhotosTableSegue sender:self];
}

- (PlacesViewModelAdapter *)adapter {
  if (!_adapter) {
    _adapter = [[PlacesViewModelAdapter alloc] init];
  }
  
  return _adapter;
}

- (id<NetworkTasksFactory>)tasksFactory {
  if (!_tasksFactory) {
    _tasksFactory = [ProtocolsFactory networkProtocol];
  }
  
  return _tasksFactory;
}

@end

NS_ASSUME_NONNULL_END
