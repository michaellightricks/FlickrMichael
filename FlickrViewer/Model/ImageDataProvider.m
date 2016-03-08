// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "ImageDataProvider.h"

#import "NSURLSessionHelper.h"
#import "NSURLSessionTaskCancelToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageDataProvider()

/// URLSession to perform network operations with.
@property (strong, nonatomic) NSURLSession *session;

@end

@implementation ImageDataProvider

- (instancetype)initWithURLSession:(NSURLSession *)session {
  if (self = [super init]) {
    self.session = session;
  }
  
  return self;
}

- (id<CancelTokenProtocol>)loadImageDataFromUrl:(NSURL *)url
                                     completion:(loadImageDataCompleteBlockType)completion {
  return [NSURLSessionHelper runDownloadTaskWithUrl:url session:self.session
                                         completion:^(NSData * _Nullable data,
                                                      NSURLResponse * _Nullable response,
                                                      NSError * _Nullable error,
                                                      id<CancelTokenProtocol> cancelToken) {
    completion(data, error, cancelToken);
  }];
}

@end

NS_ASSUME_NONNULL_END
