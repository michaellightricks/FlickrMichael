// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#include <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Object holding the data of the photo record.
@interface PhotoRecord : NSObject

/// Initializes the record with photo's \c url as location \c title string and \c description.
- (instancetype)initWithURL:(NSURL *)url title:(NSString *)title
                description:(NSString *)description NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// Photo's location URL.
@property (strong, nonatomic) NSURL *url;

/// Photo's title string.
@property (strong, nonatomic) NSString *title;

/// Photo's description.
@property (strong, nonatomic) NSString *imageDescription;

@end

NS_ASSUME_NONNULL_END
