//
//  GLSLSandboxViewController.h
//  GPUImageLearning
//
//  Created by Ashoka on 2019/11/18.
//  Copyright © 2019 Ashoka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GLSLSandboxModel;

@interface GLSLSandboxViewController : UIViewController

- (instancetype)initWithGLSLSandboxModel:(GLSLSandboxModel *)model;

@end

NS_ASSUME_NONNULL_END
