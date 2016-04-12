// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PhotosSourceFlickr.h"

#import "FlickrFetcher.h"
#import "NSURLSessionTaskCancelToken.h"
#import "NSURLSessionTasksFactory.h"
#import "PhotoRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotosSourceFlickrByPlace()

/// Place id (specified in init) where to look for photos.
@property (strong, nonatomic) NSString *placeID;

@end

@implementation PhotosSourceFlickrByPlace

- (instancetype)initWithPlaceID:(NSString *)placeID
                   tasksFactory:(id<NetworkTasksFactory>)factory {
  if (self = [super initWithTasksFactory:factory]) {
    self.placeID = placeID;
  }
  
  return self;
}

- (id<CancelTokenProtocol>)requestPhotoRecordsWithMaxCount:(NSUInteger)count
                                                completion:(PhotoRecordsBlockType)completion {
  NSURL *photosInPlaceURL = [FlickrFetcher URLforPhotosInPlace:self.placeID maxResults:(int)count];
  
  return [self.tasksFactory runDataTaskWithUrl:photosInPlaceURL
                                    completion:^(NSData * _Nullable data,
                                                 NSURLResponse * _Nullable response,
                                                 id<CancelTokenProtocol> cancelToken) {
    NSDictionary<NSString *, id> *photosDict = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
    
    [self createPhotoRecords:photosDict completion:completion cancelToken:cancelToken];
  }];
}

- (void)createPhotoRecords:(NSDictionary *)photosDict
                completion:(PhotoRecordsBlockType)completion
               cancelToken:(id<CancelTokenProtocol>)cancelToken {
  NSMutableArray<PhotoRecord *> *photoRecordsArray = [[NSMutableArray alloc] init];
  
  for (NSDictionary *photoDict in [photosDict valueForKeyPath:FLICKR_RESULTS_PHOTOS]) {
    if (cancelToken.cancelled) {
      completion(nil, cancelToken);
      return;
    }

    [photoRecordsArray addObject:[self createPhotoRecord:photoDict]];
  }
 
  completion(photoRecordsArray, cancelToken);
}

- (PhotoRecord *)createPhotoRecord:(NSDictionary *)photoDict {
  NSURL *photoURL = [FlickrFetcher URLforPhoto:photoDict format:FlickrPhotoFormatLarge];

  NSString *description = [photoDict valueForKey:FLICKR_PHOTO_DESCRIPTION];
  if (!description.length) {
    description = @"Unknown";
  }
  
  NSString *title = [photoDict valueForKey:FLICKR_PHOTO_TITLE] ?: description;
  if (!title.length) {
    title = @"Unknown";
  }
  
  PhotoRecord *record = [[PhotoRecord alloc] initWithURL:photoURL title:title
                                             description:description];

  return record;
}

@end

NS_ASSUME_NONNULL_END
