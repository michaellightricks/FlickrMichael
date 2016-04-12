// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that manages history and acts as photo source for history presentation.
/// History is stored in NSUserDefaults as persistant storage.
@interface HistoryPhotosSource : NSObject <PhotosSourceProtocol, PhotoHistoryProtocol>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the history with \c maxCount of history records using \c storage to load records.
- (instancetype)initWithMaxCount:(NSUInteger)maxCount
               persistantStorage:(id<PersistancyProvider>)storage NS_DESIGNATED_INITIALIZER;

/// Returns snapshot of history items.
- (NSArray<PhotoRecord *> *)historySnapshotWithCount:(NSUInteger)count;

/// Maximum count of records in history.
@property (readonly, nonatomic) NSUInteger maxCount;

@end

NS_ASSUME_NONNULL_END
