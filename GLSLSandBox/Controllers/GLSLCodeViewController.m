//
//  GLSLCodeViewController.m
//  GLSLSandBox
//
//  Created by Ashoka on 2019/12/15.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import "GLSLCodeViewController.h"
#import <WebKit/WebKit.h>

@interface GLSLCodeViewController ()

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation GLSLCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.webView loadFileURL:[self editorURL] allowingReadAccessToURL:[self editorURL].URLByDeletingLastPathComponent];
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    return _webView;
}

- (NSURL *)editorURL {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"index" ofType:@".html" inDirectory:@"CodeMirrorEditor"];
    return [NSURL fileURLWithPath:path];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
