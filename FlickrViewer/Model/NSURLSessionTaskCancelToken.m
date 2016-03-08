// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "NSURLSessionTaskCancelToken.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLSessionTaskCancelToken

- (instancetype)init {
  if (self = [super init]) {
    _cancelled = false;
  }
  
  return self;
}

- (void)cancel {
  @synchronized(self) {
    _cancelled = true;
    [self.task cancel];
  }
}

@end

NS_ASSUME_NONNULL_END
