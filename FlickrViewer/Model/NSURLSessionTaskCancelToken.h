// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Implementation of CancelTokenProtocol for NSURLSesssionTask objects.
@interface NSURLSessionTaskCancelToken : NSObject <CancelTokenProtocol>

/// Associated cancellable operation.
@property (strong, nonatomic) NSURLSessionTask *task;

@end

NS_ASSUME_NONNULL_END
