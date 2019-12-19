//
//  GLSLCodeViewController.h
//  GLSLSandBox
//
//  Created by Ashoka on 2019/12/15.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GLSLSandboxModel;

@interface GLSLCodeViewController : UIViewController

@property (nonatomic, strong) GLSLSandboxModel *glslModel;
@property (nonatomic, assign) BOOL readOnly;

@end

NS_ASSUME_NONNULL_END
