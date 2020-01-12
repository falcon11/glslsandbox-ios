//
//  GLSLSandboxViewController.m
//  GPUImageLearning
//
//  Created by Ashoka on 2019/11/18.
//  Copyright © 2019 Ashoka. All rights reserved.
//

#import "GLSLSandboxViewController.h"
#import "GPUImage.h"
#import "GLSLSandboxOutput.h"
#import "GLSLSandboxModel.h"
#import "GLSLCodeViewController.h"

@interface GLSLSandboxViewController ()

@property (nonatomic, strong) GLSLSandboxOutput *sandboxOutput;
@property (nonatomic, weak) GPUImageView *imageView;
@property (nonatomic, strong) GLSLSandboxModel *glslSandboxModel;

@end

@implementation GLSLSandboxViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.canViewCode = YES;
    }
    return self;
}

- (instancetype)initWithGLSLSandboxModel:(GLSLSandboxModel *)model {
    self = [self init];
    if (self) {
        self.glslSandboxModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect frame = self.view.bounds;
    self.view.backgroundColor = [UIColor whiteColor];
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:frame];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:imageView];
    imageView.center = self.view.center;
    self.imageView = imageView;
//    self.sandboxOutput = [[GLSLSandboxOutput alloc] initWidthFragementShaderString:kGPUImageSourceGarlandFragmentShaderString];
//    self.sandboxOutput = [[GLSLSandboxOutput alloc] init];
//    self.sandboxOutput = [[GLSLSandboxOutput alloc] initWithFragmentShaderFromFile:@"Rabbit"];
    self.sandboxOutput = [self sandboxOutputWithModel:self.glslSandboxModel];
    self.sandboxOutput.framebufferSize = frame.size;
    [self.sandboxOutput addTarget:imageView];
    [imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    if (_canViewCode) {
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Code" style:UIBarButtonItemStylePlain target:self action:@selector(handleViewCode:)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

//- (void)orientationChanged:(NSNotification *)note {
//    self.sandboxOutput.framebufferSize = self.view.bounds.size;
//    [self.sandboxOutput startRender];
//}

- (void)viewDidLayoutSubviews {
    if (!CGSizeEqualToSize(self.sandboxOutput.framebufferSize, self.imageView.bounds.size)) {
        self.sandboxOutput.framebufferSize = self.imageView.bounds.size;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.sandboxOutput startRender];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sandboxOutput stopRender];
}

- (GLSLSandboxOutput *)sandboxOutputWithModel:(GLSLSandboxModel *)model {
    GLSLSandboxOutput *sandboxOutput = nil;
    switch (model.fshType) {
        case EmbedFshName:
            sandboxOutput = [[GLSLSandboxOutput alloc] initWithFragmentShaderFromFile:model.fshFileName];
            break;
        case FshString:
            sandboxOutput = [[GLSLSandboxOutput alloc] initWidthFragementShaderString:model.fshString];
            break;
        case FshFilePath: {
            NSString *fshString = [model sourceCode];
            sandboxOutput = [[GLSLSandboxOutput alloc] initWidthFragementShaderString:fshString];
            break;
        }
        default:
            sandboxOutput = [[GLSLSandboxOutput alloc] init];
            break;
    }
    if (sandboxOutput == nil) {
        sandboxOutput = [[GLSLSandboxOutput alloc] init];
    }
    return sandboxOutput;
}

- (void)handleGesture:(UIGestureRecognizer *)gesture {
    CGPoint position = [gesture locationInView:self.imageView];
    self.sandboxOutput.mousePosition = CGSizeMake(position.x / self.imageView.bounds.size.width, 1 - position.y / self.imageView.bounds.size.height);
}

- (void)handleViewCode:(UIBarButtonItem *)barItem {
    GLSLCodeViewController *vc = [[GLSLCodeViewController alloc] init];
    vc.glslModel = self.glslSandboxModel;
    vc.readOnly = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    [self.sandboxOutput stopRender];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

@end
