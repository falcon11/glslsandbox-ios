//
//  GLSLSandboxOut.h
//  GPUImageLearning
//
//  Created by Ashoka on 2019/11/17.
//  Copyright © 2019 Ashoka. All rights reserved.
//

#import "GPUImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLSLSandboxOutput : GPUImageOutput

@property (nonatomic, assign) CGSize framebufferSize;
@property (nonatomic, assign) CGSize mousePosition;

- (instancetype)init;
- (instancetype)initWidthFragementShaderString:(NSString *)fShaderString;
- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename;
- (void)startRender;
- (void)stopRender;

@end

NS_ASSUME_NONNULL_END
