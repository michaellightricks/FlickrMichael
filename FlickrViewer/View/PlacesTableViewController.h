// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PhotoPresenter.h"
#import "TableViewController.h"
#import "TableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// View controller that manages the places table view.
@interface PlacesTableViewController : TableViewController<TableViewModelDelegate>

/// Object that handles photo presentation.
@property (strong, nonatomic) PhotoPresenter *photoPresenter;

@end

NS_ASSUME_NONNULL_END
