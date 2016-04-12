// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "TableViewController.h"

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController()

/// Token of the last executed load task.
@property (strong, nonatomic, nullable) id<CancelTokenProtocol> lastTaskToken;

@end

@implementation TableViewController

- (void)setViewModel:(TableViewModel *)viewModel {
  _viewModel = viewModel;
  
  self.tableView.delegate = _viewModel;
  self.tableView.dataSource = _viewModel;
  
  [self reloadData:self.refreshControl];
}

- (IBAction)reloadData:(id)sender {
  [self.refreshControl beginRefreshing];
  
  self.lastTaskToken =
      [self.viewModel reloadRowsWithCompletion:^(id<CancelTokenProtocol> cancelToken) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self.lastTaskToken != cancelToken) {
        return;
      }

      [self.refreshControl endRefreshing];

      if (!cancelToken.cancelled) {
        [self.tableView reloadData];
      }
    });
  }];
}

- (void)dealloc {
  [self.lastTaskToken cancel];
}

@end

NS_ASSUME_NONNULL_END
