// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Object holding the data of place.
@interface PlaceRecord : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Initilizes the place record with unique identifier \c placeID \c title, \c country and
/// \c details.
- (instancetype)initWithPlaceID:(NSString *)placeID title:(NSString *)title
                        country:(NSString *)country
                        details:(NSString *)details NS_DESIGNATED_INITIALIZER;

/// Places unique string identifier.
@property (readonly, nonatomic) NSString *placeID;

// Place's textual title.
@property (readonly, nonatomic) NSString *title;

/// String contains any additional detailed information of the place.
@property (readonly, nonatomic) NSString *details;

/// Country of the place.
@property (readonly, nonatomic) NSString *country;

@end

NS_ASSUME_NONNULL_END
