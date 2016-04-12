// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "FlickrSource.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Provider of image data by given \c url.
@interface ImageDataProvider : FlickrSource <ImageDataProviderProtocol>
@end

NS_ASSUME_NONNULL_END
