// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Provider of image data by given \c url.
@interface ImageDataProvider : NSObject <ImageDataProviderProtocol>

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the provider with url \c session.
- (instancetype)initWithURLSession:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/// Asynchronously loads image data at given \c url.
- (id<CancelTokenProtocol>)loadImageDataFromUrl:(NSURL *)url
                                     completion:(loadImageDataCompleteBlockType)completion;

@end

NS_ASSUME_NONNULL_END
