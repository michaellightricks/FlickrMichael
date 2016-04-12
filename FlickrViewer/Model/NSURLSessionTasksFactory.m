// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "NSURLSessionTasksFactory.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLSessionTasksFactory

- (instancetype)initWithSession:(NSURLSession *)session {
  if (self = [super init]) {
    _session = session;
  }
  
  return self;
}

- (NSError *)errorWithMessage:(NSString *)message {
  return [NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorUnknown
                         userInfo:@{@"message" : message}];
}

- (NSError *)cancelError {
  return [NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorCancelled userInfo:nil];
}

- (void)runTask:(NSURLSessionTask *)task withCancelToken:(NSURLSessionTaskCancelToken *)token {
  token.task = task;
  [task resume];
}

- (id<CancelTokenProtocol>)runDataTaskWithUrl:(NSURL *)url
                                   completion:(dataTaskCompletionBlockType)completion {
  NSURLSessionTaskCancelToken *token = [[NSURLSessionTaskCancelToken alloc] init];
  
  NSURLSessionDataTask *dataTask =
      [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,
                                                            NSURLResponse * _Nullable response,
                                                            NSError * _Nullable error) {
    if (error) {
      [token cancelWithError:error];
    }
    
    completion(data, response, token);
  }];

  [dataTask resume];

  return token;
}

- (id<CancelTokenProtocol>)runDownloadTaskWithUrl:(NSURL *)url
                                       completion:(dataTaskCompletionBlockType)completion {
  NSURLSessionTaskCancelToken *token = [[NSURLSessionTaskCancelToken alloc] init];
  
  NSURLSessionDownloadTask *downloadTask =
      [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
    NSData *data = nil;
    if (error) {
      [token cancelWithError:error];
    } else {
      data = [NSData dataWithContentsOfURL:location];
    }
  
    completion(data, response, token);
  }];
  
  [downloadTask resume];

  return token;
}
   
@end

NS_ASSUME_NONNULL_END
