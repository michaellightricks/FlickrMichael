// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Controller handling the logic of main view. Main view contains activity indicator and scroll
/// view inside a container view as view loads contoller will load the first photo's data frome the
/// first top flickr place and ask the scrollview controller to download it and show.
@interface MainViewController : UIViewController
@end

NS_ASSUME_NONNULL_END
