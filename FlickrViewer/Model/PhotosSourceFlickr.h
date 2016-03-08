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

- (instancetype)initWithURLSession:(NSURLSession *)session NS_UNAVAILABLE;

/// Initializes the source with specific \c placeID to get photos from and \c session to perform
/// network operations with.
- (instancetype)initWithPlaceID:(NSString *)placeID
                        session:(NSURLSession *)session NS_DESIGNATED_INITIALIZER;

/// Async operation to provide the collection of \c count photos records taken at specified place.
- (id <CancelTokenProtocol>)requestPhotoRecordsWithMaxCount:(NSUInteger)count
                                                 completion:(photoRecordsBlockType)completion;

@end

NS_ASSUME_NONNULL_END
