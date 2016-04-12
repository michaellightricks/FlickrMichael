// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that translates the cell model to UI cell.
@protocol TableViewCellAdapter <NSObject>

/// Fills the \c cell according to model \c row
- (void)fillCell:(UITableViewCell *)cell fromRow:(id)row;

/// Returns the section for model \c row
- (NSString *)getSectionKeyForRow:(id)row;

@end

/// Completion block for cancellable action.
typedef void(^CancellableCompletionBlockType)(id<CancelTokenProtocol> cancelToken);

/// Completion block for reloading of multiple rows.
typedef void(^ReloadDataCompletionBlockType)(NSArray *rows, id<CancelTokenProtocol> cancelToken);

/// Delegate of the \c TableViewModel handles data loading and row selection.
@protocol TableViewModelDelegate <NSObject>

/// Loads the data asynchrnously.
- (id<CancelTokenProtocol>)loadDataWithCompletion:(ReloadDataCompletionBlockType)completion;

/// Called when user has selected cell of the some model \c row.
- (void)rowSelected:(id)row;

@end

/// View model for UITableView handles row layout and model to cell translation.
@interface TableViewModel : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype) init NS_UNAVAILABLE;

/// Initializes the view model with \c adapter and \c delegate.
- (instancetype) initWithAdapter:(id<TableViewCellAdapter>)adapter
                        delegate:(id<TableViewModelDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// Requests reload of model data.
- (id<CancelTokenProtocol>)reloadRowsWithCompletion:(CancellableCompletionBlockType)completion;

@end

NS_ASSUME_NONNULL_END
