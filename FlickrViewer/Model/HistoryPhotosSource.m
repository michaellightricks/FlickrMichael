// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "HistoryPhotosSource.h"

#import "NSURLSessionTaskCancelToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryPhotosSource()

/// Array of history records.
@property (readonly, nonatomic) NSMutableArray<PhotoRecord *> *records;

/// Object that handles persistant storage load and store.
@property (readonly, nonatomic) id<PersistancyProvider> persistantStorage;

@end

@implementation HistoryPhotosSource

- (instancetype)initWithMaxCount:(NSUInteger)maxCount
               persistantStorage:(id<PersistancyProvider>)storage {
  if (maxCount == 0) {
    return nil;
  }
  
  if (self = [super init]) {
    _maxCount = maxCount;
    _persistantStorage = storage;
    
    [self loadFromDefaults];
  }
  
  return self;
}

- (void)loadFromDefaults {
  NSArray<PhotoRecord *> *snapshot = [self.persistantStorage loadPhotoRecords];
  
  _records = [NSMutableArray arrayWithArray:snapshot];
  
  if (self.records.count > self.maxCount) {
    [self.records removeObjectsInRange:NSMakeRange(self.maxCount,
                                                   self.records.count - self.maxCount)];
  }
}

- (void)addPhotoRecord:(PhotoRecord *)record {
  @synchronized(self.records) {
    NSUInteger idx = [self.records indexOfObjectPassingTest:^BOOL(PhotoRecord *otherRecord,
                                                                  NSUInteger idx,
                                                                  BOOL * __unused stop) {
        return [record.url isEqual:otherRecord.url];
    }];
    
    if (idx != NSNotFound) {
      [self.records removeObjectAtIndex:idx];
    }

    if (self.records.count >= self.maxCount) {
        [self.records removeLastObject];
    }

    [self.records insertObject:record atIndex:0];
    
    [self savePersistantly];
  }
}

- (id<CancelTokenProtocol>)requestPhotoRecordsWithMaxCount:(NSUInteger)count
                                                completion:(PhotoRecordsBlockType)completion {
  NSURLSessionTaskCancelToken *token = [[NSURLSessionTaskCancelToken alloc] init];
  NSArray<PhotoRecord *> *recordsCopy = [self historySnapshotWithCount:count];
  completion(recordsCopy, token);
  
  return token;
}

- (NSArray<PhotoRecord *> *)historySnapshotWithCount:(NSUInteger)count {
  @synchronized(self.records) {
    NSRange range = NSMakeRange(0, MIN(self.records.count, count));
    return (NSArray<PhotoRecord *> *)[self.records subarrayWithRange:range];
  }
}

- (void)savePersistantly {
  NSArray<PhotoRecord *> *snapshot = [self historySnapshotWithCount:self.maxCount];
  [self.persistantStorage savePhotoRecords:snapshot];
}

@end

NS_ASSUME_NONNULL_END
