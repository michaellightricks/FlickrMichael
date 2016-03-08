// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "NSURLSessionTaskCancelToken.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Block type for completion of the data task.
typedef void(^dataTaskCompletionBlockType)(NSData * _Nullable data,
                                           NSURLResponse * _Nullable response,
                                           NSError * _Nullable error,
                                           id<CancelTokenProtocol> cancelToken);

/// Helper class that wraps common NSURLSession operations.
@interface NSURLSessionHelper : NSObject

/// Returns new instance of generic error with user defined \c message
+ (NSError *)createErrorWithMessage:(NSString *)message;

/// Returns new instance of the \c NSError filled with appropriate data for cancellation status.
+ (NSError *)createCancelError;

/// Runs cancellable data \c task and returns associated cancel token.
+ (id<CancelTokenProtocol>)runDataTaskWithUrl:(NSURL *)url
                                      session:(NSURLSession *)session
                                   completion:(dataTaskCompletionBlockType)completion;

/// Runs cancellable download data \c task and returns associated cancel token.
+ (id<CancelTokenProtocol>)runDownloadTaskWithUrl:(NSURL *)url
                                          session:(NSURLSession *)session
                                       completion:(dataTaskCompletionBlockType)completion;

@end

NS_ASSUME_NONNULL_END
