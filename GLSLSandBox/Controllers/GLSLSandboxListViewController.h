//
//  GLSLSandboxListViewController.h
//  GPUImageLearning
//
//  Created by Ashoka on 2019/11/18.
//  Copyright © 2019 Ashoka. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    EmbedFshName,
    FshString,
    FshFilePath,
} GLSLSandboxFshType;

@interface GLSLSandboxModel : NSObject

@property (nonatomic, assign) GLSLSandboxFshType fshType;
@property (nonatomic, strong) NSString *fshFileName;
@property (nonatomic, strong) NSString *fshString;
@property (nonatomic, strong) NSString *fshFilePath;

@end

@interface GLSLSandboxListViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
