// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "ScrollViewController.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewController() <UIScrollViewDelegate>

/// Scroll view to show the image.
@property (strong, nonatomic) UIScrollView *scrollView;

/// Image view to hold the content image inside the scroll view.
@property (strong, nonatomic) UIImageView *imageView;

/// Indicator of download activity.
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

/// Current running task cancellation token.
@property (strong, nonatomic) id<CancelTokenProtocol> currentToken;

/// Title of displayed image.
@property (strong, nonatomic) NSString *imageTitle;

@end

@implementation ScrollViewController

- (instancetype)initWithUrl:(NSURL *)url title:(NSString *)title
                   provider:(id<ImageDataProviderProtocol>)provider {
  if (self = [super initWithNibName:nil bundle:nil]) {
    _imageUrl = url;
    _imageTitle = title;
    _imageDataProvider = provider;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.activityView startAnimating];
  
  self.title = self.imageTitle;
  
  self.currentToken =
  [self.imageDataProvider loadImageDataFromUrl:self.imageUrl
                                    completion:^(NSData * _Nullable data,
                                                 id<CancelTokenProtocol> cancelToken) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.activityView stopAnimating];
    });
    
    if (cancelToken.cancelled) {
      return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      UIImage *image = [UIImage imageWithData:data];
      [self setImage:image];
    });
  }];
}

- (void)dealloc {
  [self.currentToken cancel];
}

- (void)loadView {
  UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
  self.view = contentView;

  self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
  self.scrollView.delegate = self;
  self.scrollView.scrollEnabled = YES;
  self.scrollView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.scrollView];
  
  self.imageView = [[UIImageView alloc] init];
  [self.scrollView addSubview: self.imageView];
  
  self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
  self.activityView.color = [UIColor grayColor];
  self.activityView.hidesWhenStopped = YES;
  [self.view addSubview:self.activityView];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  self.scrollView.frame = self.view.bounds;
  self.activityView.frame = self.view.bounds;
  
  if (self.imageView.image) {
    [self updateZoomBoundsForImageView:self.imageView];
    self.scrollView.zoomScale = MAX(self.scrollView.minimumZoomScale, self.scrollView.zoomScale);
  }
}

- (void)setImage:(UIImage *)image {
  self.imageView.image = image;
  
  [self updateContentSizeForImage:image];
  [self updateZoomBoundsForImageView:self.imageView];
  [self zoomToFit:self.imageView];
}

- (void)updateContentSizeForImage:(UIImage *)image {
  self.scrollView.contentSize = image.size;
  self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
}

- (void)updateZoomBoundsForImageView:(UIImageView *)imageView {
  self.scrollView.minimumZoomScale = [self minZoomScaleForImageView:imageView];
  self.scrollView.maximumZoomScale = MAX(4.0, 3 * self.scrollView.minimumZoomScale);
}

- (CGFloat)minZoomScaleForImageView:(UIImageView *)imageView {
  if (imageView.bounds.size.width == 0) {
    return 0.1;
  }
  
  CGFloat widthScale = self.scrollView.bounds.size.width / imageView.bounds.size.width;
  CGFloat heightScale = self.scrollView.bounds.size.height / imageView.bounds.size.height;
  
  return MIN(widthScale, heightScale);
}

- (void)zoomToFit:(UIImageView *)imageView {
  self.scrollView.zoomScale = [self aspectFitZoomScaleForImageView:imageView];
}

- (CGFloat)aspectFitZoomScaleForImageView:(UIImageView *)imageView {
  CGFloat widthScale = self.scrollView.bounds.size.width / imageView.bounds.size.width;
  CGFloat heightScale = self.scrollView.bounds.size.height / imageView.bounds.size.height;
  
  return MAX(widthScale, heightScale);
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
  return self.imageView;
}

@end

NS_ASSUME_NONNULL_END
