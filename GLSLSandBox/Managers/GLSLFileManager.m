//
//  GLSLFileManager.m
//  GLSLSandBox
//
//  Created by ashoka on 2020/1/7.
//  Copyright © 2020 ashoka. All rights reserved.
//

#import "GLSLFileManager.h"
#import <FCFileManager.h>
#import "GLSLSandboxModel.h"

@interface GLSLFileManager ()

@property (nonatomic, strong) NSString *baseDirectory;

@end

@implementation GLSLFileManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static GLSLFileManager *fileManager;
    static NSString *directory = @"FragmentShader";
    dispatch_once(&onceToken, ^{
        NSString *baseDirectory = [FCFileManager pathForDocumentsDirectoryWithPath:directory];
        fileManager = [[GLSLFileManager alloc] initWithBaseDirectory:baseDirectory];
    });
    return fileManager;
}

- (instancetype)initWithBaseDirectory:(NSString *)baseDirectory {
    self = [super init];
    if (self) {
        self.baseDirectory = baseDirectory;
        [FCFileManager createDirectoriesForPath:baseDirectory];
    }
    return self;
}

- (NSString *)generateFileName {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@.fsh", dateString];
}

- (void)saveGLSLSandboxModelToDisk:(GLSLSandboxModel *)model callback:(SaveModelCallback)callback {
    if (model.fshType == FshString) {
        NSString *path = [self.baseDirectory stringByAppendingPathComponent:[self generateFileName]];
        [FCFileManager writeFileAtPath:path content:model.fshString];
    }
}

@end
