// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PhotoPresenter.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Factory of basic model protocols for ease of use in view layer.
@interface ProtocolsFactory : NSObject

/// Implementation of network protocol to perform async network tasks.
+ (id<NetworkTasksFactory>)networkProtocol;

/// Implementation of places source.
+ (id<PlacesSourceProtocol>)placesSource;

/// Implementation of photos metadata source.
+ (id<PhotosSourceProtocol>)photosFromHistorySource;

/// Implementation of history management protocol.
+ (id<PhotoHistoryProtocol>)historyProtocol;

/// Implementation of image data provider protocol.
+ (id<ImageDataProviderProtocol>)createImageProvider;

@end

NS_ASSUME_NONNULL_END
