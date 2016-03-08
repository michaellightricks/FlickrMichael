// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PlaceRecord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PlaceRecord

- (instancetype)initWithPlaceID:(NSString *)placeID title:(NSString *)title
                        country:(NSString *)country details:(NSString *)details {
  if (self = [super init]) {
    _placeID = placeID;
    _title = title;
    _country = country;
    _details = details;
  }

  return self;
}

@end

NS_ASSUME_NONNULL_END
