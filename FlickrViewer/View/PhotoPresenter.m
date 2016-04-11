// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PhotoPresenter.h"

#import "ScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoPresenter()

/// Provider that loads the image data.
@property (readonly, nonatomic) id<ImageDataProviderProtocol> imageDataProvider;

/// Protocol that handles the photo history.
@property (readonly, nonatomic) id<PhotoHistoryProtocol> history;

@end

@implementation PhotoPresenter

- (instancetype)initWithImageProvider:(id<ImageDataProviderProtocol>)provider
                              history:(nullable id<PhotoHistoryProtocol>)history{
  if (self = [super init]) {
    _imageDataProvider = provider;
    _history = history;
  }
  
  return self;
}

- (void)showPhoto:(PhotoRecord *)record
    inNavigationController:(UINavigationController *)controller {
  [self.history addPhotoRecord:record];
  
  ScrollViewController *viewController =
      [[ScrollViewController alloc] initWithUrl:record.url title:record.title
                                       provider:self.imageDataProvider];
  
  [controller pushViewController:viewController animated:NO];
}

@end

NS_ASSUME_NONNULL_END
