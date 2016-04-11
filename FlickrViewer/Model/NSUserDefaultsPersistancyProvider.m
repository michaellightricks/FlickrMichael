// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "NSUserDefaultsPersistancyProvider.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSUserDefaultsPersistancyProvider

static NSString * const kPhotoHistoryKey = @"PhotoHistory";

- (NSArray<PhotoRecord *> *)loadPhotoRecords {
  NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
  
  NSData *data = [currentDefaults objectForKey:kPhotoHistoryKey];
  NSArray<PhotoRecord *> *snapshot = [NSKeyedUnarchiver unarchiveObjectWithData:data];

  return snapshot;
}

- (void)savePhotoRecords:(NSArray<PhotoRecord *> *)records {
  NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
  [currentDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:records]
                      forKey:kPhotoHistoryKey];
}

@end

NS_ASSUME_NONNULL_END
