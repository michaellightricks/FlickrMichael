// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "PlacesSourceFlickr.h"

#import "FlickrFetcher.h"
#import "NSURLSessionHelper.h"
#import "PlaceRecord.h"

NS_ASSUME_NONNULL_BEGIN

#define FLICKR_PLACE_CITY "locality._content"
#define FLICKR_PLACE_COUNTRY "country._content"
#define FLICKR_PLACE_COUNTY "county._content"
#define FLICKR_PLACE_REGION "region._content"

@implementation PlacesSourceFlickr

- (id<CancelTokenProtocol>)requestPlaceRecordsWithMaxCount:(NSUInteger)count
                                                completion:(placeRecordsBlockType)completion {
  NSURL *topPlacesUrl = [FlickrFetcher URLforTopPlaces];
  
  return [NSURLSessionHelper runDataTaskWithUrl:topPlacesUrl
                                        session:self.session
                                     completion:^(NSData * _Nullable data,
                                                  NSURLResponse * _Nullable response,
                                                  NSError * _Nullable error,
                                                  id<CancelTokenProtocol> cancelToken) {
    NSDictionary<NSString *, id> *topPlaces = [NSJSONSerialization JSONObjectWithData:data
                                                                              options:0
                                                                                error:nil];
    [self parseAndFetchPlacesFromDictionary:topPlaces withMaxCount:count
                                 completion:completion token:cancelToken];
  }];
}

- (void)parseAndFetchPlacesFromDictionary:(NSDictionary<NSString *, id> *)topPlaces
                             withMaxCount:(NSUInteger)maxCount
                               completion:(placeRecordsBlockType)completion
                             token:(id<CancelTokenProtocol>)token {
  NSMutableArray<PlaceRecord *> *placeRecords = [[NSMutableArray alloc] init];

  NSArray *places = [topPlaces valueForKeyPath:FLICKR_RESULTS_PLACES];
  NSUInteger count = MIN([places count], maxCount);
  
  for (NSUInteger i = 0; i < count; ++i) {
    if (token.cancelled) {
      completion(nil, [NSURLSessionHelper createCancelError]);
      return;
    }
    
    NSDictionary *place = places[i];
    NSString *placeID = place[FLICKR_PLACE_ID];
    NSString *placeContent = place[FLICKR_PLACE_NAME];
    
    [placeRecords addObject:[self getRecordByPlaceID:placeID content:placeContent]];
  }
  
  completion(placeRecords, nil);
}

- (PlaceRecord *)getRecordByPlaceID:(NSString *)placeID content:(NSString *)content {
  NSArray<NSString *> *placeProps = [content componentsSeparatedByString:@","];
  
  NSRange range = [self rangeForDetailsFromContent:content];
  NSString *details = [content substringWithRange:range];
  
  PlaceRecord *record = [[PlaceRecord alloc] initWithPlaceID:placeID
                                                       title:placeProps[0]
                                                     country:placeProps[placeProps.count - 1]
                                                     details:details];

  return record;
}

- (NSRange)rangeForDetailsFromContent:(NSString *)content {
  NSRange range;
  range.location = [content rangeOfString:@","].location;
  
  range.length = [content rangeOfString:@"," options:NSBackwardsSearch].location - range.location;
  
  range.location += 1;
  if (range.length > 0) {
    range.length -= 1;
  }
  else {
    range.length = content.length - range.location;
  }
  
  return range;
}

@end

NS_ASSUME_NONNULL_END
