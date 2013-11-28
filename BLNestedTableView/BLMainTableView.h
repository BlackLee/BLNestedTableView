//
//  BLMainTableView.h
//  BLNestedTableViewDemo
//
//  Created by Black.Lee on 13-11-21.
//  Copyright (c) 2013年 Black.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLMainTableView;

@protocol BLNestedTableViewDataSource <NSObject>

- (NSInteger) numberOfSectionsInMainTableView:(BLMainTableView*) mainTableView;

- (NSInteger)mainTableView:(BLMainTableView *)mainTableView numberOfRowsInSection:(NSInteger)section;

- (CGFloat) mainTableView:(BLMainTableView *)mainTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell*) mainTableView:(BLMainTableView *)mainTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 height of nestedTableView
 */
- (CGFloat) mainTableView:(BLMainTableView *)mainTableView heightForNestedTableViewForRowAtIndexPath:(NSIndexPath *)indexPath;




- (NSInteger) numberOfSectionsInNestedTableView:(UITableView*) nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath;

- (NSInteger)nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath numberOfRowsInSection:(NSInteger)section;

- (CGFloat) nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell*) nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol BLNestedTableViewDelegate <NSObject>
- (UITableViewStyle) nestedTableViewStyle;

- (void) mainTableView:(BLMainTableView *)mainTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void) nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface BLMainTableView : UITableView
@property(nonatomic,weak) id<BLNestedTableViewDataSource> ntDataSource;
@property(nonatomic,weak) id<BLNestedTableViewDelegate> ntDelegate;
@end
