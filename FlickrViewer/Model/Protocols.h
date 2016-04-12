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

/// Requests the cancellation of the associated task with specified \c error.
- (void)cancelWithError:(NSError *)error;

/// Returns the cancellation status of the associated operation.
@property (readonly, nonatomic) BOOL cancelled;

/// Error that occured while task was being executed.
@property (readonly, nonatomic) NSError *error;

@end

/// Block type for completion of the photo records request.
typedef void(^PhotoRecordsBlockType)(NSArray<PhotoRecord *> * _Nullable photoRecords,
                                     id<CancelTokenProtocol> cancelToken);

/// Provider of the PhotoRecords collection.
@protocol PhotosSourceProtocol <NSObject>

/// Performs async retrieval of the PhotoRecords objects (photo metadata) collection with max count.
/// Use the CancelTokenProtocol cancel property to cancel this request.
- (id<CancelTokenProtocol>)requestPhotoRecordsWithMaxCount:(NSUInteger)count
                                                completion:(PhotoRecordsBlockType)completion;
@end

/// Block type for completion of the place records request.
typedef void(^placeRecordsBlockType)(NSArray<PlaceRecord *> * _Nullable placeRecords,
                                     id<CancelTokenProtocol> cancelToken);

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
                                              id<CancelTokenProtocol> cancelToken);

/// Provider of the image data by given \c url.
@protocol ImageDataProviderProtocol <NSObject>

/// Asynchrnously loads image data by provided \c url.
- (id<CancelTokenProtocol>)loadImageDataFromUrl:(NSURL *)url
                                     completion:(loadImageDataCompleteBlockType)completion;

@end

/// Protocol that provides access to history management
@protocol PhotoHistoryProtocol <NSObject>

/// Adds photo \c record to history
- (void)addPhotoRecord:(PhotoRecord *)record;

@end

/// Object that handles loading and storing photo records to persistant storage.
@protocol PersistancyProvider <NSObject>

/// Loads the array of photo records from persistant storage.
- (NSArray<PhotoRecord *> *)loadPhotoRecords;

/// Saves array of photo records to persistant storage.
- (void)savePhotoRecords:(NSArray<PhotoRecord *> *)records;

@end

/// Block type for completion of the data task.
typedef void(^dataTaskCompletionBlockType)(NSData * _Nullable data,
                                           NSURLResponse * _Nullable response,
                                           id<CancelTokenProtocol> cancelToken);

@protocol NetworkTasksFactory <NSObject>

/// Returns new instance of generic error with user defined \c message
- (NSError *)errorWithMessage:(NSString *)message;

/// Returns new instance of the \c NSError filled with appropriate data for cancellation status.
- (NSError *)cancelError;

/// Runs cancellable data \c task and returns associated cancel token.
- (id<CancelTokenProtocol>)runDataTaskWithUrl:(NSURL *)url
                                   completion:(dataTaskCompletionBlockType)completion;

/// Runs cancellable download data \c task and returns associated cancel token.
- (id<CancelTokenProtocol>)runDownloadTaskWithUrl:(NSURL *)url
                                       completion:(dataTaskCompletionBlockType)completion;

@end

NS_ASSUME_NONNULL_END
