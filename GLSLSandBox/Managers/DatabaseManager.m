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

- (BOOL)saveGLSLSandboxModelToDatabase:(GLSLSandboxModel *)model {
    BOOL success = [self.db executeUpdate:@"insert into fragmentshader (type, filename, code, path) values (?, ?, ?, ?)", @(model.fshType), model.fshFileName, model.fshString ?: [NSNull null], model.fshFilePath ?: [NSNull null]];
    if (!success) {
        NSError *error = [self.db lastError];
        NSLog(@"save model to db error: %@", error);
    }
    return success;
}

- (NSMutableArray<GLSLSandboxModel *> *)getGLSLSandboxModelList {
    FMResultSet *s = [self.db executeQuery:@"select * from fragmentshader"];
    NSMutableArray<GLSLSandboxModel *> *list = [NSMutableArray new];
    while ([s next]) {
        NSDictionary *dict = [s resultDictionary];
        GLSLSandboxModel *model = [GLSLSandboxModel new];
        model.fshType = [dict[@"type"] intValue];
        model.fshFileName = dict[@"filename"];
        model.fshString = [s columnIsNull:@"code"] ? nil : dict[@"code"];
        model.fshFilePath = [s columnIsNull:@"path"] ? nil : dict[@"path"];
        [list insertObject:model atIndex:0];
    }
    return list;
}

- (void)dealloc
{
    [self.db close];
}

@end
