// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "NSURLSessionTaskCancelToken.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLSessionTaskCancelToken

@synthesize cancelled = _cancelled;
@synthesize error = _error;

- (instancetype)init {
  if (self = [super init]) {
    _cancelled = false;
    _error = nil;
  }
  
  return self;
}

- (void)cancel {
  [self cancelWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorCancelled
                                        userInfo:nil]];
}

- (void)cancelWithError:(NSError *)error {
  @synchronized(self) {
    _error = error;
    _cancelled = true;
    [self.task cancel];
  }
}

@end

NS_ASSUME_NONNULL_END
