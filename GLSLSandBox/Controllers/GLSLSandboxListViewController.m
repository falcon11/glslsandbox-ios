//
//  GLSLSandboxListViewController.m
//  GPUImageLearning
//
//  Created by Ashoka on 2019/11/18.
//  Copyright © 2019 Ashoka. All rights reserved.
//

#import "GLSLSandboxListViewController.h"
#import "GLSLSandboxViewController.h"

@implementation GLSLSandboxModel

@end

@interface GLSLSandboxListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray<GLSLSandboxModel *> *sandboxDemosList;

@end

@implementation GLSLSandboxListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView = tableView;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (NSArray<GLSLSandboxModel *> *)sandboxDemosList {
    if (!_sandboxDemosList) {
        NSArray *defaultDemos = @[
            @"Example",
            @"Garland",
            @"Rabbit",
            @"AshokaChakra",
            @"VDrop",
            @"SpreadLight",
            @"Flame",
            @"Round",
            @"GithubCat",
            @"ProteanClouds",
            @"Cybertruck",
        ];
        NSMutableArray *sandboxDemosList = [NSMutableArray new];
        for (NSString *fileName in defaultDemos) {
            GLSLSandboxModel *model = [[GLSLSandboxModel alloc] init];
            model.fshType = EmbedFshName;
            model.fshFileName = fileName;
            [sandboxDemosList addObject:model];
        }
        _sandboxDemosList = sandboxDemosList;
    }
    return _sandboxDemosList;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sandboxDemosList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"sandbox-cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.sandboxDemosList[indexPath.row].fshFileName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GLSLSandboxModel *model = self.sandboxDemosList[indexPath.row];
    GLSLSandboxViewController *viewController = [[GLSLSandboxViewController alloc] initWithGLSLSandboxModel:model];
    viewController.title = model.fshFileName;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
