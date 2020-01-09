//
//  GLSLSandboxCustomViewController.m
//  GLSLSandBox
//
//  Created by Ashoka on 2019/12/15.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import "GLSLSandboxCustomViewController.h"
#import "GLSLSandboxModel.h"
#import "DatabaseManager.h"
#import "GLSLSandboxViewController.h"

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
    [self loadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.customGLSLArray = [[DatabaseManager shareInstance] getGLSLSandboxModelList];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GLSLSandboxModel *model = self.customGLSLArray[indexPath.row];
    GLSLSandboxViewController *vc = [[GLSLSandboxViewController alloc] initWithGLSLSandboxModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
