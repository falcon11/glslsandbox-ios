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
#import "DatabaseManager.h"

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

- (NSString *)baseDirectory {
    return _baseDirectory;
}

- (NSString *)glslsandboxModelAbsolutePath:(GLSLSandboxModel *)model {
    if (model.fshType == FshFilePath) {
        return [self.baseDirectory stringByAppendingPathComponent:model.fshFilePath];
    }
    return nil;
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
        NSString *fileName = [self generateFileName];
        NSString *path = [self.baseDirectory stringByAppendingPathComponent:fileName];
        NSError *error = nil;
        [FCFileManager writeFileAtPath:path content:model.fshString error:&error];
        if (error) {
            if (callback) callback(error, nil);
            return;
        }
        GLSLSandboxModel *newModel = [GLSLSandboxModel new];
        newModel.fshType = FshFilePath;
        newModel.fshFileName = model.fshFileName;
        newModel.fshFilePath = fileName;
        BOOL success = [[DatabaseManager shareInstance] saveGLSLSandboxModelToDatabase:newModel];
        if (success) {
            if (callback) callback(nil, newModel);
        } else if (callback) {
            callback(error, nil);
        }
    }
}

@end
