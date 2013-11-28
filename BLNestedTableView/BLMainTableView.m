//
//  BLMainTableView.m
//  BLNestedTableViewDemo
//
//  Created by Black.Lee on 13-11-21.
//  Copyright (c) 2013年 Black.Lee. All rights reserved.
//

#import "BLMainTableView.h"
#import "UIView+ObjectTag.h"
#import "BLTableContainerCell.h"

@interface BLMainTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation BLMainTableView {
    NSMutableArray *expandIndexPathes;
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isMemberOfClass:[BLMainTableView class]]) {
        return [self.ntDataSource numberOfSectionsInMainTableView:self];
    } else {
        return 1;   // only 1 section for nested tableview
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isMemberOfClass:[BLMainTableView class]]) {
        int sec = indexPath.section;
        int row = indexPath.row;
        int rowForMainCell = row;
        for (NSIndexPath *idxPath in expandIndexPathes) {
            if (idxPath.section == sec) {
                if (indexPath.row < row) {
                    rowForMainCell += 1;
                }
            }
        }
        NSIndexPath *mainIndexPath = [NSIndexPath indexPathForRow:rowForMainCell inSection:sec];

        float height = 0;
        if ([self showingNestedTableViewInSection:sec row:row]) {
            height = [self.ntDataSource mainTableView:self heightForNestedTableViewForRowAtIndexPath:mainIndexPath];
        } else {
            height = [self.ntDataSource mainTableView:self heightForRowAtIndexPath:mainIndexPath];
        }
        return height;
    } else {
        return [self.ntDataSource nestedTableView:tableView forMainTableViewRowAtIndexPath:tableView.objectTag heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isMemberOfClass:[BLMainTableView class]]) {
        int numberOfRowsInSectionInMainTableView = [self.ntDataSource mainTableView:self numberOfRowsInSection:section];
        int numberOfExpandedRowsInSection = 0;
        for (NSIndexPath *idxPath in expandIndexPathes) {
            if (idxPath.section == section) {
                numberOfExpandedRowsInSection += 1;
            }
        }
        int totalRows = numberOfRowsInSectionInMainTableView + numberOfExpandedRowsInSection;
        return totalRows;
    } else {
        int rows = [self.ntDataSource nestedTableView:tableView forMainTableViewRowAtIndexPath:tableView.objectTag numberOfRowsInSection:section];
        return rows;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isMemberOfClass:[BLMainTableView class]]) {
        return [self _mainTableCellForRowAtIndexPath:indexPath];
    } else {
        NSIndexPath *mainIndexPath = tableView.objectTag;
        return [self.ntDataSource nestedTableView:tableView forMainTableViewRowAtIndexPath:mainIndexPath cellForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell*) _mainTableCellForRowAtIndexPath:(NSIndexPath*) indexPath {
    int sec = indexPath.section;
    int row = indexPath.row;
    int rowForMainCell = row;
    
    if ([self showingNestedTableViewInSection:sec row:row]) {
        rowForMainCell -= 1;
        for (NSIndexPath *idxPath in expandIndexPathes) {
            if (idxPath.section == sec) {
                if (idxPath.row < row) {
                    rowForMainCell -= 1;
                }
            }
        }
        NSIndexPath *mainIndexPath = [NSIndexPath indexPathForRow:rowForMainCell inSection:sec];
        BLTableContainerCell *tableContainerCell = [self dequeueReusableCellWithIdentifier:@"tableContainerCell"];
        if (!tableContainerCell) {
            UITableViewStyle tableViewStyle = [self.ntDelegate nestedTableViewStyle];
            tableContainerCell = [[BLTableContainerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableContainerCell" nestedTableViewStyle:tableViewStyle];
            tableContainerCell.delegate = self;
        }
        tableContainerCell.nestedTableView.objectTag = mainIndexPath;
        
        [tableContainerCell.nestedTableView reloadData];
        return tableContainerCell;
    } else {
        NSIndexPath *mainIndexPath = [NSIndexPath indexPathForRow:rowForMainCell inSection:sec];
        return [self.ntDataSource mainTableView:self cellForRowAtIndexPath:mainIndexPath];
    }
}

#pragma mark - tableView delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int sec = indexPath.section;
    int row = indexPath.row;
    int rowForMainCell = row;
    
    if ([tableView isMemberOfClass:[BLMainTableView class]]) {
        if ([self showingNestedTableViewInSection:indexPath.section row:indexPath.row+1]) {
            [self collapseNestedViewOfIndexPath:indexPath];
            [self deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            [self expandNestedViewOfIndexPath:indexPath];
            [self insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        for (NSIndexPath *idxPath in expandIndexPathes) {
            if (idxPath.section == sec) {
                if (idxPath.row < row) {
                    rowForMainCell -= 1;
                }
            }
        }
        
        [self.ntDelegate mainTableView:self didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:rowForMainCell inSection:sec]];
    } else {
        [self.ntDelegate nestedTableView:tableView forMainTableViewRowAtIndexPath:tableView.objectTag didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:rowForMainCell inSection:sec]];
    }
}

#pragma mark - handle logic of expandIndexPathes

- (void) expandNestedViewOfIndexPath:(NSIndexPath*) indexPath { // 存储展开后的那行
    int row = indexPath.row;
    for (int i = 0; i < expandIndexPathes.count; i++) {
        NSIndexPath *idxPath = expandIndexPathes[i];
        if (idxPath.section == indexPath.section) {
            if (idxPath.row > indexPath.row) {
                [expandIndexPathes removeObject:idxPath];
                [expandIndexPathes insertObject:[NSIndexPath indexPathForRow:idxPath.row+1 inSection:indexPath.section] atIndex:i];
            }
        }
    }
    [expandIndexPathes addObject:[NSIndexPath indexPathForRow:row+1 inSection:indexPath.section]];
    [self filterDuplicateIndexPath];
}
- (void) collapseNestedViewOfIndexPath:(NSIndexPath*) indexPath {
    for (int i = 0; i < expandIndexPathes.count; i++) {
        NSIndexPath *idxPath = expandIndexPathes[i];
        if (idxPath.section == indexPath.section) {
            if (idxPath.row - 1 == indexPath.row) {
                [expandIndexPathes removeObject:idxPath];
                i -= 1;
            } else if (idxPath.row > indexPath.row) {
                [expandIndexPathes removeObject:idxPath];
                [expandIndexPathes insertObject:[NSIndexPath indexPathForRow:idxPath.row-1 inSection:indexPath.section] atIndex:i];
            }
        }
    }
    [self filterDuplicateIndexPath];
}

- (void) filterDuplicateIndexPath {
    NSMutableSet *set = [NSMutableSet setWithArray:expandIndexPathes];
    [expandIndexPathes removeAllObjects];
    for (id indexPath in set) {
        [expandIndexPathes addObject:indexPath];
    }
}

- (BOOL) showingNestedTableViewInSection:(int) section row:(int) row {
    BOOL showing = NO;
    if (expandIndexPathes.count > 0) {
        if (row == -44) { // 判断是否在某个Section中
            for (NSIndexPath *idxPath in expandIndexPathes) {
                if (idxPath.section == section) {
                    showing = YES;
                    break;
                }
            }
        } else {
            for (NSIndexPath *idxPath in expandIndexPathes) {
                if (idxPath.section == section && idxPath.row == row) {
                    showing = YES;
                    break;
                }
            }
        }
    }
    return showing;
}

#pragma mark - overwrite delegates

- (void) setDataSource:(id<UITableViewDataSource>)dataSource {
    assert(NO);
}
- (void) setDelegate:(id<UITableViewDelegate>)delegate {
    assert(NO);
}
- (void) reloadData {
    [expandIndexPathes removeAllObjects];
    [super reloadData];
}

#pragma mark - initializers

- (void) initializeMyVariables {
    expandIndexPathes = [NSMutableArray array];
    super.dataSource = self;
    super.delegate = self;
}

- (id) init {
    self = [super init];
    if (self) {
        [self initializeMyVariables];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeMyVariables];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeMyVariables];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initializeMyVariables];
    }
    return self;
}

@end
