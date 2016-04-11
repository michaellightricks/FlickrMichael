// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "HistoryViewController.h"

#import "PhotosTableViewController.h"
#import "ProtocolsFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation HistoryViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  PhotosTableViewController *photosViewController =
      (PhotosTableViewController *)self.viewControllers[0];
  photosViewController.photosSource = [ProtocolsFactory photosFromHistorySource];
  
  photosViewController.presenter =
      [[PhotoPresenter alloc] initWithImageProvider:[ProtocolsFactory createImageProvider]
                                            history:nil];
}

@end

NS_ASSUME_NONNULL_END
