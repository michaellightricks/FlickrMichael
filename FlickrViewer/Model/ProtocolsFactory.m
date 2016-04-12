// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "ProtocolsFactory.h"

#import "HistoryPhotosSource.h"
#import "ImageDataProvider.h"
#import "NSURLSessionTasksFactory.h"
#import "NSUserDefaultsPersistancyProvider.h"
#import "PhotosSourceFlickr.h"
#import "PlacesSourceFlickr.h"


NS_ASSUME_NONNULL_BEGIN

@implementation ProtocolsFactory

const NSUInteger kMaxHistoryRecordsCount = 50;

+ (id<NetworkTasksFactory>)networkProtocol {
  static id<NetworkTasksFactory> networkTasksProtocol;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    networkTasksProtocol = [[NSURLSessionTasksFactory alloc] initWithSession:session];
  });
  
  return networkTasksProtocol;
}

+ (id<PlacesSourceProtocol>)placesSource {
  static id<PlacesSourceProtocol> placesSourceProtocol;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    placesSourceProtocol =
        [[PlacesSourceFlickr alloc] initWithTasksFactory:[self networkProtocol]];
  });
  
  return placesSourceProtocol;
}

+ (HistoryPhotosSource *)historyInternal {
  static HistoryPhotosSource *history;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSUserDefaultsPersistancyProvider *storage = [[NSUserDefaultsPersistancyProvider alloc] init];
    history = [[HistoryPhotosSource alloc] initWithMaxCount:kMaxHistoryRecordsCount
                                          persistantStorage:storage];
  });
  
  return history;
}

+ (id<PhotosSourceProtocol>)photosFromHistorySource {
  return [self historyInternal];
}

+ (id<PhotoHistoryProtocol>)historyProtocol {
  return [self historyInternal];
}

+ (id<ImageDataProviderProtocol>)createImageProvider {
  return [[ImageDataProvider alloc] initWithTasksFactory:[self networkProtocol]];
}

@end

NS_ASSUME_NONNULL_END
