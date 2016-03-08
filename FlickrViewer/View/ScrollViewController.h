// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Block type for completion of image download operation.
typedef void(^downloadCompletionBlockType)(NSURL *imageURL,
                                           NSError * _Nullable error,
                                           id<CancelTokenProtocol> cancelToken);

///Contoller that handles the downloading and presentation of photo to user.
@interface ScrollViewController : UIViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil
                         bundle:(NSBundle * _Nullable)nibBundleOrNil NS_UNAVAILABLE;

/// Initializes the view controller with \c url of the image to load and \c provider.
- (instancetype)initWithUrl:(NSURL *)url
                   provider:(id<ImageDataProviderProtocol>)provider NS_DESIGNATED_INITIALIZER;

/// Provides the image data by URL.
@property (readonly, nonatomic) id<ImageDataProviderProtocol> imageDataProvider;

/// Url of the image that was requested to show.
@property (readonly, nonatomic) NSURL *imageUrl;

@end

NS_ASSUME_NONNULL_END
