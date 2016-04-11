// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PhotoPresenter.h"
#import "Protocols.h"
#import "TableViewController.h"
#import "TableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// View controller that manages the photos table view.
@interface PhotosTableViewController : TableViewController<TableViewModelDelegate>

/// Source that provides photo records to show.
@property (strong, nonatomic) id<PhotosSourceProtocol> photosSource;

/// Object that handles the photo presentation.
@property (strong, nonatomic) PhotoPresenter *presenter;

@end

NS_ASSUME_NONNULL_END
