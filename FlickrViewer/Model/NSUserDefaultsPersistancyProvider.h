// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Implementation of persistance storage provider using \c NSUserDefaults.
@interface NSUserDefaultsPersistancyProvider : NSObject <PersistancyProvider>
@end

NS_ASSUME_NONNULL_END
