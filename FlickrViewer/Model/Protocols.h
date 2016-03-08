// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "PhotoRecord.h"
#import "PlaceRecord.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that provides the way to cancel operations.
/// This object is returned as a cancellation point by async operations.
@protocol CancelTokenProtocol <NSObject>

/// Requests the cancellation of the associated operation.
- (void)cancel;

/// Returns the cancellation status of the associated operation.
@property (readonly, nonatomic) BOOL cancelled;

@end

/// Block type for completion of the photo records request.
typedef void(^photoRecordsBlockType)(NSArray<PhotoRecord *> * _Nullable photoRecords,
                                     NSError * _Nullable error);

/// Provider of the PhotoRecords collection.
@protocol PhotosSourceProtocol <NSObject>

/// Performs async retrieval of the PhotoRecords objects (photo metadata) collection with max count.
/// Use the CancelTokenProtocol cancel property to cancel this request.
- (id<CancelTokenProtocol>)requestPhotoRecordsWithMaxCount:(NSUInteger)count
                                                completion:(photoRecordsBlockType)completion;
@end

/// Block type for completion of the place records request.
typedef void(^placeRecordsBlockType)(NSArray<PlaceRecord *> * _Nullable placeRecords,
                                     NSError * _Nullable error);

/// Provider of the PlaceRecord collection.
@protocol PlacesSourceProtocol <NSObject>

/// Performs async retrieval of the PlaceRecords objects (place metadata) collection
/// stopping after retrieving \c count records.
/// Use the CancelTokenProtocol cancel property to cancel this request.
- (id<CancelTokenProtocol>)requestPlaceRecordsWithMaxCount:(NSUInteger)count
                                                completion:(placeRecordsBlockType)completion;
@end

/// Block type for completion of the image data download.
typedef void(^loadImageDataCompleteBlockType)(NSData * _Nullable imageData,
                                              NSError * _Nullable error,
                                              id<CancelTokenProtocol> cancelToken);

/// Provider of the image data by given \c url.
@protocol ImageDataProviderProtocol <NSObject>

/// Asynchrnously loads image data by provided \c url.
- (id<CancelTokenProtocol>)loadImageDataFromUrl:(NSURL *)url
                                     completion:(loadImageDataCompleteBlockType)completion;

@end

NS_ASSUME_NONNULL_END
