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

typedef void(^SaveModelCallback)(NSError *error, GLSLSandboxModel *newModel);

@interface GLSLFileManager : NSObject

- (void)saveGLSLSandboxModelToDisk:(GLSLSandboxModel *)model callback:(SaveModelCallback)callback;

@end

NS_ASSUME_NONNULL_END
