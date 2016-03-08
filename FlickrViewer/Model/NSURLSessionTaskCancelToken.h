// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import <Foundation/Foundation.h>

#import "Protocols.h"

NS_ASSUME_NONNULL_BEGIN

/// Implementation of CancelTokenProtocol for NSURLSesssionTask objects.
@interface NSURLSessionTaskCancelToken : NSObject <CancelTokenProtocol>

/// Requests the cancellation of the associated operation.
- (void)cancel;

/// Associated cancellable operation.
@property (strong, nonatomic) NSURLSessionTask *task;

/// Returns the cancellation status of the associated operation.
@property (readonly, nonatomic) BOOL cancelled;

@end

NS_ASSUME_NONNULL_END
