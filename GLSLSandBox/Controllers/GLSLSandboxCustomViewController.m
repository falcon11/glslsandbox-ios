//
//  GLSLSandboxCustomViewController.m
//  GLSLSandBox
//
//  Created by Ashoka on 2019/12/15.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import "GLSLSandboxCustomViewController.h"
#import "GLSLSandboxListViewController.h"

@interface GLSLSandboxCustomViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray<GLSLSandboxModel *> *customGLSLArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GLSLSandboxCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.customGLSLArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"cell-identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    GLSLSandboxModel *model = self.customGLSLArray[indexPath.row];
    cell.textLabel.text = model.fshFileName;
    return cell;
}

@end
