// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PhotosSourceFlickr.h"

#import "FlickrFetcher.h"
#import "NSURLSessionHelper.h"
#import "NSURLSessionTaskCancelToken.h"
#import "PhotoRecord.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotosSourceFlickrByPlace()

/// Place id (specified in init) where to look for photos.
@property (strong, nonatomic) NSString *placeID;

@end

@implementation PhotosSourceFlickrByPlace

- (instancetype)initWithPlaceID:(NSString *)placeID session:(NSURLSession *)session {
  if (self = [super initWithURLSession:session]) {
    self.placeID = placeID;
  }
  
  return self;
}

- (id<CancelTokenProtocol>)requestPhotoRecordsWithMaxCount:(NSUInteger)count
                                                completion:(photoRecordsBlockType)completion {
  NSURL *photosInPlaceURL = [FlickrFetcher URLforPhotosInPlace:self.placeID maxResults:(int)count];
  
  return [NSURLSessionHelper runDataTaskWithUrl:photosInPlaceURL
                                        session:self.session
                                     completion:^(NSData * _Nullable data,
                                                  NSURLResponse * _Nullable response,
                                                  NSError * _Nullable error,
                                                  id<CancelTokenProtocol> cancelToken) {
    NSDictionary<NSString *, id> *photosDict = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
    
    [self createPhotoRecords:photosDict completion:completion cancelToken:cancelToken];
  }];
}

- (void)createPhotoRecords:(NSDictionary *)photosDict
                completion:(photoRecordsBlockType)completion
               cancelToken:(id<CancelTokenProtocol>)cancelToken {
  NSMutableArray<PhotoRecord *> *photoRecordsArray = [[NSMutableArray alloc] init];
  
  for (NSDictionary *photoDict in [photosDict valueForKeyPath:FLICKR_RESULTS_PHOTOS]) {
    if (cancelToken.cancelled) {
      completion(nil, [NSURLSessionHelper createCancelError]);
      return;
    }

    [photoRecordsArray addObject:[self createPhotoRecord:photoDict]];
  }
 
  completion(photoRecordsArray, nil);
}

- (PhotoRecord *)createPhotoRecord:(NSDictionary *)photoDict {
  NSURL *photoURL = [FlickrFetcher URLforPhoto:photoDict format:FlickrPhotoFormatLarge];
  NSString *description = [photoDict valueForKey:FLICKR_PHOTO_DESCRIPTION] ?: @"Unknown";
  NSString *title = [photoDict valueForKey:FLICKR_PHOTO_TITLE] ?: description;
  
  PhotoRecord *record = [[PhotoRecord alloc] initWithURL:photoURL title:title
                                             description:description];

  return record;
}

@end

NS_ASSUME_NONNULL_END
