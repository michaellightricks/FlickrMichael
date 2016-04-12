// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PlacesViewModelAdapter.h"

#import "PlaceRecord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlacesViewModelAdapter

- (void)fillCell:(UITableViewCell *)cell fromRow:(id)row {
  PlaceRecord *record = (PlaceRecord *)row;
  cell.textLabel.text = record.title;
  cell.detailTextLabel.text = record.details;
}

- (NSString *)getSectionKeyForRow:(id)row {
  PlaceRecord *record = (PlaceRecord *)row;
  
  return record.country;
}

@end

NS_ASSUME_NONNULL_END
