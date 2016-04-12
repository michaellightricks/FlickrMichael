// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "NSURLSessionTaskCancelToken.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Helper class that wraps common NSURLSession operations.
@interface NSURLSessionTasksFactory : NSObject <NetworkTasksFactory>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the factory with \c session.
- (instancetype)initWithSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/// Session which is used to run network tasks.
@property (readonly, nonatomic) NSURLSession *session;

@end

NS_ASSUME_NONNULL_END
