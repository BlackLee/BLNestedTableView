//
//  BLTableContainerCell.h
//  BLNestedTableViewDemo
//
//  Created by Black.Lee on 13-11-28.
//  Copyright (c) 2013年 Black.Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLTableContainerCell : UITableViewCell
@property(nonatomic,strong) UITableView *nestedTableView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier nestedTableViewStyle:(UITableViewStyle) nestedStyle;
@property(nonatomic,strong) id delegate;
@end
