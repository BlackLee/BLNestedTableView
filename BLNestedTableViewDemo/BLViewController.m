//
//  BLViewController.m
//  BLNestedTableViewDemo
//
//  Created by Black.Lee on 13-11-21.
//  Copyright (c) 2013年 Black.Lee. All rights reserved.
//

#import "BLViewController.h"
#import "BLNestedTableView.h"

@interface BLViewController () <BLNestedTableViewDataSource, BLNestedTableViewDelegate>
@property(nonatomic,weak) IBOutlet BLMainTableView *tableView;
@end

@implementation BLViewController {
    NSMutableArray *expandedSectionRow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.ntDataSource = self;
    self.tableView.ntDelegate = self;
    expandedSectionRow = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInMainTableView:(BLMainTableView*) mainTableView {
    return 3;
}

- (NSInteger)mainTableView:(BLMainTableView *)mainTableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat) mainTableView:(BLMainTableView *)mainTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell*) mainTableView:(BLMainTableView *)mainTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MainTableViewCell";
    UITableViewCell *cell = [mainTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row];
    return cell;
}

- (void) mainTableView:(BLMainTableView *)mainTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"mainTableView: didSelectRowAtIndexPath:  %d-%d", indexPath.section, indexPath.row);
}

- (CGFloat) mainTableView:(BLMainTableView *)mainTableView heightForNestedTableViewForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22 * 3 + 36 + 36;
}

- (NSInteger) numberOfSectionsInNestedTableView:(UITableView*) nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath {
    return 1;
}

- (NSInteger)nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat) nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 22;
}

- (UITableViewCell*) nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"NestedTableViewCell";
    UITableViewCell *cell = [nestedTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"   %d-%d   %d-%d", mainIndexPath.section, mainIndexPath.row, indexPath.section, indexPath.row];
    return cell;
}

- (void) nestedTableView:(UITableView *)nestedTableView forMainTableViewRowAtIndexPath:(NSIndexPath *)mainIndexPath didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"nestedTableView: didSelect:   %d-%d     %d-%d", mainIndexPath.section, mainIndexPath.row, indexPath.section, indexPath.row);
}

- (UITableViewStyle) nestedTableViewStyle {
    return UITableViewStyleGrouped;
}

@end
