// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PhotoRecord.h"

NS_ASSUME_NONNULL_BEGIN

@implementation PhotoRecord

- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title
                description:(NSString *)description {
  if (self = [super init]) {
    _url = url;
    _title = title;
    _imageDescription = description;
  }
  
  return self;
}

@end

NS_ASSUME_NONNULL_END
