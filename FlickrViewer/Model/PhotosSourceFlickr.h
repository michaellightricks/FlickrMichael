// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "FlickrSource.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Implemntation of the photo source that provides the collection of Flickr photos
/// from specific flickr place specified by its \c placeid.
@interface PhotosSourceFlickrByPlace : FlickrSource <PhotosSourceProtocol>

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTasksFactory:(id<NetworkTasksFactory>)factory NS_UNAVAILABLE;

/// Initializes the source with specific \c placeID to get photos from and \c session to perform
/// network operations with.
- (instancetype)initWithPlaceID:(NSString *)placeID
                   tasksFactory:(id<NetworkTasksFactory>)factory NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
