// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "NSURLSessionTaskCancelToken.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that implements basic functionality shared by all Flickr entities sources.
@interface FlickrSource : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the source with network tasks \c factory
- (instancetype)initWithTasksFactory:(id<NetworkTasksFactory>)factory
    NS_DESIGNATED_INITIALIZER;

/// Used to perform network tasks.
@property (readonly, nonatomic) id<NetworkTasksFactory> tasksFactory;

@end

NS_ASSUME_NONNULL_END
