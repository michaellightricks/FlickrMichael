// Copyright (c) 2016 Lightricks. All rights reserved.
// Created by Michael Kupchick.

#import "TableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSMutableArray<NSArray *> SectionsArrayType;

typedef NSMutableDictionary<NSString *, NSMutableArray *> SectionsDictType;

@interface TableViewModel()

/// Rows stored as mutable array of sections as arrays of model data.
@property (strong, nonatomic) SectionsArrayType *rowsBySection;

/// Array of sections names.
@property (strong, nonatomic) NSArray<NSString *> *sectionsKeys;

/// Cell adapter that translates the model row data to UI cell.
@property (weak, readonly, nonatomic) id<TableViewCellAdapter> cellAdapter;

/// View model delegate that handles data reloading and cell selection.
@property (weak, readonly, nonatomic) id<TableViewModelDelegate> delegate;

@end

@implementation TableViewModel

- (instancetype) initWithAdapter:(id<TableViewCellAdapter>)adapter
                        delegate:(id<TableViewModelDelegate>)delegate {
  if (self = [super init]) {
    _cellAdapter = adapter;
    _delegate = delegate;
  }
  
  return self;
}

- (id<CancelTokenProtocol>)reloadRowsWithCompletion:(CancellableCompletionBlockType)completion {
  return [self.delegate loadDataWithCompletion:^(NSArray *rows,
                                                 id<CancelTokenProtocol> token) {
    if (!token.cancelled) {
      SectionsDictType *sectionsDict = [self sectionDictionaryFromRows:rows];
      
      self.sectionsKeys = [sectionsDict allKeys];
      self.rowsBySection = [self sortedRowsBySections:sectionsDict];
    }
    
    completion(token);
  }];
}

- (SectionsDictType *)sectionDictionaryFromRows:(NSArray *)rows {
  SectionsDictType *sectionsDict = [NSMutableDictionary dictionary];
  
  for (id row in rows) {
    NSString *section = [self.cellAdapter getSectionKeyForRow:row];
    NSMutableArray *sectionRows = sectionsDict[section];
    if (!sectionRows) {
      sectionRows = [NSMutableArray array];
      sectionsDict[section] = sectionRows;
    }
    
    [sectionRows addObject:row];
  }
  
  return sectionsDict;
}

- (SectionsArrayType *)sortedRowsBySections:(SectionsDictType *)sectionsDict {
  SectionsArrayType *result = [NSMutableArray array];
  
  [sectionsDict enumerateKeysAndObjectsUsingBlock:^(NSString * __unused key, NSMutableArray *obj,
                                                   BOOL * __unused stop) {
    [result addObject:obj];
  }];
 
  return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.rowsBySection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.rowsBySection[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  [self.cellAdapter fillCell:cell fromRow:[self getRowAtIndexPath:indexPath]];

  return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView
         titleForHeaderInSection:(NSInteger)section {
  return self.sectionsKeys[section];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  [self.delegate rowSelected:[self getRowAtIndexPath:indexPath]];
}

- (id)getRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.rowsBySection[indexPath.section][indexPath.row];
}

@end

NS_ASSUME_NONNULL_END
