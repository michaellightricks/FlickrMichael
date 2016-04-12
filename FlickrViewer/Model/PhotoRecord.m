// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PhotoRecord.h"

#import "EXTKeyPathCoding.h"

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

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
  self = [self initWithURL:[decoder decodeObjectForKey:@keypath(self, url)]
                     title:[decoder decodeObjectForKey:@keypath(self, title)]
               description:[decoder decodeObjectForKey:@keypath(self, imageDescription)]];
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_url forKey:@keypath(self, url)];
  [encoder encodeObject:_title forKey:@keypath(self, title)];
  [encoder encodeObject:_imageDescription forKey:@keypath(self, imageDescription)];
}

@end

NS_ASSUME_NONNULL_END
