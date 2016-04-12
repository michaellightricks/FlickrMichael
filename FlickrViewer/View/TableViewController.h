// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// Base table view controller.
@interface TableViewController : UITableViewController

/// Table view model that handles the properties and layout of rows.
@property (strong, nonatomic) TableViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
