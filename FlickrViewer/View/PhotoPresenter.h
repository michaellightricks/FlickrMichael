// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PhotoRecord.h"
#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Object that presents the photo scroll view to user.
@interface PhotoPresenter : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initializes the presenter with image data \c provider  and \c history manager. When \c history
/// is \c nil \c showPhoto call will not be recorded.
- (instancetype)initWithImageProvider:(id<ImageDataProviderProtocol>)provider
                              history:(nullable id<PhotoHistoryProtocol>)history
    NS_DESIGNATED_INITIALIZER;

/// Shows photo from \c record in specified navigation controller.
- (void)showPhoto:(PhotoRecord *)record inNavigationController:(UINavigationController *)controller;

@end

NS_ASSUME_NONNULL_END
