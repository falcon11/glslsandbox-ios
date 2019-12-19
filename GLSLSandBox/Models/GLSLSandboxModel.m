//
//  GLSLSandboxModel.m
//  GLSLSandBox
//
//  Created by ashoka on 2019/12/19.
//  Copyright © 2019 ashoka. All rights reserved.
//

#import "GLSLSandboxModel.h"

@implementation GLSLSandboxModel

- (NSString *)sourceCode {
    NSString *sourceCode = @"";
    switch (self.fshType) {
        case EmbedFshName:{
            NSString *path = [[NSBundle mainBundle] pathForResource:self.fshFileName ofType:@"fsh"];
            sourceCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            break;
        }
        case FshString:{
            sourceCode = self.fshString;
            break;
        }
        case FshFilePath:
            sourceCode = [NSString stringWithContentsOfFile:self.fshFilePath encoding:NSUTF8StringEncoding error:nil];
            break;
        default:
            break;
    }
    return sourceCode;
}

@end
