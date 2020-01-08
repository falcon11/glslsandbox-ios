//
//  DatabaseManager.m
//  GLSLSandBox
//
//  Created by ashoka on 2020/1/8.
//  Copyright © 2020 ashoka. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDB/FMDB.h>
#import <FCFileManager/FCFileManager.h>
#import "GLSLSandboxModel.h"

@interface DatabaseManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DatabaseManager

static const NSString *fragmentShaderTableName = @"fragmentshader";

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static DatabaseManager *databaseManager;
    dispatch_once(&onceToken, ^{
        databaseManager = [[DatabaseManager alloc] initWithDatabaseName:@"glsl.db"];
    });
    return databaseManager;
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName {
    self = [super init];
    if (self) {
        NSString *directory = @"database";
        [FCFileManager createDirectoriesForPath:directory];
        NSString *path = [FCFileManager pathForDocumentsDirectoryWithPath:[directory stringByAppendingPathComponent:databaseName]];
        self.db = [FMDatabase databaseWithPath:path];
        if ([self.db open]) {
            [self createFragmentShaderTable];
        }
    }
    return self;
}

- (BOOL)createFragmentShaderTable {
    NSString *table = @"fragmentshader";
    if ([self.db tableExists:table]) return true;
    NSString *stmt = [NSString stringWithFormat:@"create table if not exists %@(id integer primary key autoincrement, type integer, filename text, code text, path text)", table];
    return [self.db executeUpdate:stmt];
}

- (void)saveGLSLSandboxModelToDatabase:(GLSLSandboxModel *)model callback:(SaveSandboxModelToDBCallback)callback {
    BOOL success = [self.db executeUpdate:@"insert into fragmentshader (type, filename, code, path) values (?, ?, ?, ?)", @(model.fshType), model.fshFileName, model.fshString ?: [NSNull null], model.fshFilePath ?: [NSNull null]];
    NSError *error = nil;
    if (!success) {
        error = [self.db lastError];
    }
    if (callback) callback(error);
}

- (void)dealloc
{
    [self.db close];
}

@end
