// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PhotosViewModelAdapter.h"

#import "PhotoRecord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PhotosViewModelAdapter

- (void)fillCell:(UITableViewCell *)cell fromRow:(id)row {
  PhotoRecord *record = (PhotoRecord *)row;
  cell.textLabel.text = record.title;
  cell.detailTextLabel.text = record.imageDescription;
}

- (NSString *)getSectionKeyForRow:(id)row {
  return @"";
}

@end

NS_ASSUME_NONNULL_END
