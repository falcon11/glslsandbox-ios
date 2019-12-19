//
//  GLSLSandboxMainViewController.m
//  GLSLSandBox
//
//  Created by Ashoka on 2019/12/15.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import "GLSLSandboxMainViewController.h"
#import "GLSLSandboxListViewController.h"
#import "GLSLSandboxCustomViewController.h"
#import "GLSLCodeViewController.h"
#import "GLSLSandboxModel.h"

@interface GLSLSandboxMainViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) GLSLSandboxListViewController *embedViewController;
@property (nonatomic, strong) GLSLSandboxCustomViewController *customViewController;
@property (nonatomic, strong) UIBarButtonItem *addButtonItem;

@end

@implementation GLSLSandboxMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.titleView = self.segmentedControl;
    [self addChildViewController:self.embedViewController];
    [self.view addSubview:self.embedViewController.view];
    [self.embedViewController didMoveToParentViewController:self];
    [self addChildViewController:self.customViewController];
    [self.view addSubview:self.customViewController.view];
    [self.customViewController didMoveToParentViewController:self];
    self.customViewController.view.hidden = YES;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Embed", @"Custom"]];
        [_segmentedControl addTarget:self action:@selector(handleSegmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
    }
    return _segmentedControl;
}

- (GLSLSandboxListViewController *)embedViewController {
    if (!_embedViewController) {
        _embedViewController = [[GLSLSandboxListViewController alloc] init];
    }
    return _embedViewController;
}

- (GLSLSandboxCustomViewController *)customViewController {
    if (!_customViewController) {
        _customViewController = [[GLSLSandboxCustomViewController alloc] init];
    }
    return _customViewController;
}

- (UIBarButtonItem *)addButtonItem {
    if (!_addButtonItem) {
        _addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(handleAddCustomGLSL:)];
    }
    return _addButtonItem;
}

- (void)handleSegmentedValueChanged:(UISegmentedControl *)segmentedControl {
    self.embedViewController.view.hidden = segmentedControl.selectedSegmentIndex != 0;
    self.customViewController.view.hidden = segmentedControl.selectedSegmentIndex != 1;
    self.navigationItem.rightBarButtonItem = self.customViewController.view.isHidden ? nil : self.addButtonItem;
}

- (void)handleAddCustomGLSL:(UIBarButtonItem *)buttonItem {
    GLSLCodeViewController *vc = [[GLSLCodeViewController alloc] init];
    GLSLSandboxModel *glslModel = [GLSLSandboxModel new];
    glslModel.fshType = EmbedFshName;
    glslModel.fshFileName = @"Flame";
    vc.glslModel = glslModel;
    vc.readOnly = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
