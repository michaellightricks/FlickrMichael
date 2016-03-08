// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "NSURLSessionTaskCancelToken.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that implements basic functionality shared by all Flickr entities sources.
@interface FlickrSource : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initilizes the source with url \c session, which will be used for all network requests.
- (instancetype)initWithURLSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/// URLSession to perform network operations with.
@property (readonly, nonatomic) NSURLSession *session;

@end

NS_ASSUME_NONNULL_END
