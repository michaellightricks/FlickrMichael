// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "FlickrSource.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FlickrSource

- (instancetype)initWithTasksFactory:(id<NetworkTasksFactory>)factory {
  if (self = [super init]) {
    _tasksFactory = factory;
  }
  
  return self;
}

@end

NS_ASSUME_NONNULL_END
