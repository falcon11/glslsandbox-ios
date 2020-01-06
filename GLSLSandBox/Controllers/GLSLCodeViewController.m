//
//  GLSLCodeViewController.m
//  GLSLSandBox
//
//  Created by Ashoka on 2019/12/15.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import "GLSLCodeViewController.h"
#import <WebKit/WebKit.h>
#import "GLSLSandboxModel.h"
#import "GLSLSandboxViewController.h"

@interface GLSLCodeViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *previewButton;

@end

@implementation GLSLCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.navigationDelegate = self;
    [self.webView loadFileURL:[self editorURL] allowingReadAccessToURL:[self editorURL].URLByDeletingLastPathComponent];
    [self setupRightBarItems];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

- (NSURL *)editorURL {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"index" ofType:@".html" inDirectory:@"CodeMirrorEditor"];
    return [NSURL fileURLWithPath:path];
}

- (void)setupRightBarItems {
    NSMutableArray *rightBarItems = [NSMutableArray new];
    if (!_readOnly) {
        [rightBarItems addObject:self.saveButton];
        [rightBarItems addObject:self.previewButton];
    }
    self.navigationItem.rightBarButtonItems = rightBarItems;
}

- (UIBarButtonItem *)previewButton {
    if (!_previewButton) {
        _previewButton = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(handlePreview:)];
    }
    return _previewButton;
}

- (UIBarButtonItem *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(handleSave:)];
    }
    return _saveButton;
}

- (void)loadSourceCode:(NSString *)sourceCode {
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"setCode(`%@`, %@)", sourceCode, self.readOnly ? @"true" : @"false"] completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)handlePreview:(UIBarButtonItem *)button {
    [self.webView evaluateJavaScript:@"getCode()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"error: %@;\nresult====%@", error, result);
        if (!error) {
            GLSLSandboxModel *model = [[GLSLSandboxModel alloc] init];
            model.fshType = FshString;
            model.fshString = result;
            model.fshFileName = @"Preview";
            GLSLSandboxViewController *vc = [[GLSLSandboxViewController alloc] initWithGLSLSandboxModel:model];
            vc.canViewCode = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}

/// get editor code
/// @param button button
- (void)handleSave:(UIBarButtonItem *)button {
    [self.webView evaluateJavaScript:@"getCode()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"error: %@;\nresult====%@", error, result);
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSString *sourceCode = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Flame" ofType:@"fsh"] encoding:NSUTF8StringEncoding error:nil];
    [self loadSourceCode:[self.glslModel sourceCode]];
}

@end
