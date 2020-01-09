//
//  GLSLFileManager.h
//  GLSLSandBox
//
//  Created by ashoka on 2020/1/7.
//  Copyright © 2020 ashoka. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GLSLSandboxModel;

typedef void(^SaveModelCallback)(NSError * _Nullable error, GLSLSandboxModel * _Nullable newModel);

@interface GLSLFileManager : NSObject

+ (instancetype)shareInstance;

- (NSString *)glslsandboxModelAbsolutePath:(GLSLSandboxModel *)model;

- (void)saveGLSLSandboxModelToDisk:(GLSLSandboxModel *)model callback:(SaveModelCallback)callback;

@end

NS_ASSUME_NONNULL_END
