BLNestedTableView
=================

A nested UITableView

It has two levels' tableView:
 - the main tableView is the top level view.
 - and many nestedTableViews are the second level view.

When expand a cell, it'll insert a cell after the clicked cell. 
For example, when you click cell at [section:0 row:0], then a cell will insert after it, so the NSIndexPath will be [section:0 row:1], but this won't effect the original cell of [section:0 row:1].

Clone it & run.

Screenshot
----------
<p align="center" >
  <img src="https://raw.github.com/BlackLee/BLNestedTableView/master/Screenshots/1.png" alt="BLNestedTableView" title="BLNestedTableView" style="width:248px; height:360px;">
</p>


See BLViewController.m

```objective-c

- (void) viewDidLoad {
    // set datasource and delegate
    self.tableView.ntDataSource = self;
    self.tableView.ntDelegate = self;
}



// implementation

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

- (UITableViewStyle) nestedTableViewStyle {
    return UITableViewStyleGrouped;
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

```
