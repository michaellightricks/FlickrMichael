// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "ImageDataProvider.h"

#import "NSURLSessionTaskCancelToken.h"
#import "NSURLSessionTasksFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation ImageDataProvider

- (id<CancelTokenProtocol>)loadImageDataFromUrl:(NSURL *)url
                                     completion:(loadImageDataCompleteBlockType)completion {
  return [self.tasksFactory runDownloadTaskWithUrl:url
                                        completion:^(NSData * _Nullable data,
                                                     NSURLResponse * _Nullable response,
                                                     id<CancelTokenProtocol> cancelToken) {
    completion(data, cancelToken);
  }];
}

@end

NS_ASSUME_NONNULL_END
