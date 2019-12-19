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

@interface GLSLCodeViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *saveButton;

@end

@implementation GLSLCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.navigationDelegate = self;
    [self.webView loadFileURL:[self editorURL] allowingReadAccessToURL:[self editorURL].URLByDeletingLastPathComponent];
    self.navigationItem.rightBarButtonItem = self.saveButton;
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
