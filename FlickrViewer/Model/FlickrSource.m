// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "FlickrSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrSource

- (instancetype)initWithURLSession:(NSURLSession *)session {
  if (self = [super init]) {
    _session = session;
  }
  
  return self;
}

@end

NS_ASSUME_NONNULL_END
