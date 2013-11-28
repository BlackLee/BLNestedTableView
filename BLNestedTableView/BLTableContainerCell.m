//
//  BLTableContainerCell.m
//  BLNestedTableViewDemo
//
//  Created by Black.Lee on 13-11-28.
//  Copyright (c) 2013年 Black.Lee. All rights reserved.
//

#import "BLTableContainerCell.h"

@implementation BLTableContainerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nestedTableViewStyle:(UITableViewStyle) nestedStyle {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.nestedTableView = [[UITableView alloc] initWithFrame:CGRectZero style:nestedStyle];
        self.nestedTableView.scrollEnabled = NO;
        [self addSubview:self.nestedTableView];
    }
    return self;
}

- (void) setDelegate:(id)delegate {
    self.nestedTableView.dataSource = delegate;
    self.nestedTableView.delegate = delegate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nestedTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
