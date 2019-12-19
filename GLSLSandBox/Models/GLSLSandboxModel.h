//
//  GLSLSandboxModel.h
//  GLSLSandBox
//
//  Created by ashoka on 2019/12/19.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import <Foundation/Foundation.h>

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

NS_ASSUME_NONNULL_END
