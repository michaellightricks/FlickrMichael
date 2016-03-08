// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "FlickrSource.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Implemntation of the places source that provides the collection of top Flickr places.
@interface PlacesSourceFlickr : FlickrSource <PlacesSourceProtocol>

/// Async operation to provide the collection of \c count flickr top places records.
- (id <CancelTokenProtocol>)requestPlaceRecordsWithMaxCount:(NSUInteger)count
                                                 completion:(placeRecordsBlockType)completion;

@end

NS_ASSUME_NONNULL_END
