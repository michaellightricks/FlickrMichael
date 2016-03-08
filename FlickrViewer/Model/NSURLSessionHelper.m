// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "NSURLSessionHelper.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSURLSessionHelper

+ (NSError *)createErrorWithMessage:(NSString *)message {
  return [NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorUnknown
                         userInfo:@{@"message" : message}];
}

+ (NSError *)createCancelError {
  return [NSError errorWithDomain:NSCocoaErrorDomain code:NSURLErrorCancelled userInfo:nil];
}

+ (void)runTask:(NSURLSessionTask *)task withCancelToken:(NSURLSessionTaskCancelToken *)token {
  token.task = task;
  [task resume];
}

+ (id<CancelTokenProtocol>)runDataTaskWithUrl:(NSURL *)url
                                      session:(NSURLSession *)session
                                   completion:(dataTaskCompletionBlockType)completion {
  NSURLSessionTaskCancelToken *token = [[NSURLSessionTaskCancelToken alloc] init];
  
  NSURLSessionDataTask *dataTask =
      [session dataTaskWithURL:url
             completionHandler:^(NSData * _Nullable data,
                                 NSURLResponse * _Nullable response,
                                 NSError * _Nullable error) {
    if (token.cancelled) {
      error = [NSURLSessionHelper createCancelError];
    }
    
    if (error) {
      completion(nil, nil, error, token);
      return;
    }
    
    completion(data, response, nil, token);
  }];

  [dataTask resume];

  return token;
}

+ (id<CancelTokenProtocol>)runDownloadTaskWithUrl:(NSURL *)url
                                          session:(NSURLSession *)session
                                       completion:(dataTaskCompletionBlockType)completion {
  NSURLSessionTaskCancelToken *token = [[NSURLSessionTaskCancelToken alloc] init];
  
  NSURLSessionDownloadTask *downloadTask =
      [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location,
                                                           NSURLResponse * _Nullable response,
                                                           NSError * _Nullable error) {
    if (token.cancelled) {
      error = [NSURLSessionHelper createCancelError];
    }
    
    if (error) {
      completion(nil, nil, error, token);
      return;
    }

    NSData *data = [NSData dataWithContentsOfURL:location];
  
    completion(data, response, nil, token);
  }];
  
  [downloadTask resume];

  return token;
}
   
@end

NS_ASSUME_NONNULL_END
