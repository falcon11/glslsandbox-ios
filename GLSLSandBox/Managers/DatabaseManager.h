//
//  DatabaseManager.h
//  GLSLSandBox
//
//  Created by ashoka on 2020/1/8.
//  Copyright © 2020 ashoka. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GLSLSandboxModel;

typedef void(^SaveSandboxModelToDBCallback)(NSError *error);

@interface DatabaseManager : NSObject

- (void)saveGLSLSandboxModelToDatabase:(GLSLSandboxModel *)model callback:(SaveSandboxModelToDBCallback)callback;

@end

NS_ASSUME_NONNULL_END
