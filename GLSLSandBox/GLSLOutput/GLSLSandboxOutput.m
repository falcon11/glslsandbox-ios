//
//  GLSLSandboxOut.m
//  GPUImageLearning
//
//  Created by Ashoka on 2019/11/17.
//  Copyright © 2019 Ashoka. All rights reserved.
//

#import "GLSLSandboxOutput.h"

NSString *const kSandboxVertexShaderString = SHADER_STRING
(
 attribute vec3 position;
 attribute vec2 surfacePosAttrib;
 varying vec2 surfacePosition;

 void main() {

//     surfacePosition = surfacePosAttrib;
     gl_Position = vec4(position, 1.0);

 }
);

NSString *const kSandboxFragmentShaderString = SHADER_STRING(
    precision mediump float;
    uniform float time;
    uniform vec2 mouse;
    uniform vec2 resolution;
    void main( void ) {
        vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
        float color = 0.0;
        color += sin( position.x * cos( time / 15.0 ) * 80.0 ) + cos( position.y * cos( time / 15.0 ) * 10.0 );
        color += sin( position.y * sin( time / 10.0 ) * 40.0 ) + cos( position.x * sin( time / 25.0 ) * 40.0 );
        color += sin( position.x * sin( time / 5.0 ) * 10.0 ) + sin( position.y * sin( time / 35.0 ) * 80.0 );
        color *= sin( time / 10.0 ) * 0.5;
        gl_FragColor = vec4( vec3( color, color * 0.5, sin( color + time / 3.0 ) * 0.75 ), 1.0 );
    }
);

dispatch_source_t createDispatchTimer(uint64_t interval, dispatch_queue_t queue, dispatch_block_t block) {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval, 0);
        dispatch_source_set_event_handler(timer, block);
    }
    return timer;
}

@interface GLSLSandboxContext : NSObject {
    dispatch_queue_t _timerQueue;
}

- (dispatch_queue_t)timeQueue;

@end

@implementation GLSLSandboxContext

+ (instancetype)sharedInstance
{
    static GLSLSandboxContext *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance->_timerQueue = dispatch_queue_create("com.ashoka.sandbox.pro", DISPATCH_QUEUE_SERIAL);
    });
    return sharedInstance;
}

- (dispatch_queue_t)timeQueue {
    return _timerQueue;
}

@end

@interface GLSLSandboxOutput () {
    GLint _timeUniform;
    GLint _resolutionUniform;
    GLint _mouseUniform;
    GLint _positionAttribute;
    GLint _surfacePosAttribute;
    dispatch_semaphore_t _updateTargetsSemaphore;
}

@property (nonatomic, strong) GLProgram *renderProgram;
//@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation GLSLSandboxOutput

- (instancetype)init
{
    return [self initWithVertexShaderString:kSandboxVertexShaderString fragmentShaderString:kSandboxFragmentShaderString];
}

- (instancetype)initWidthFragementShaderString:(NSString *)fShaderString {
    return [self initWithVertexShaderString:kSandboxVertexShaderString fragmentShaderString:fShaderString];
}

- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename
{
    NSString *fragmentShaderPathname = [[NSBundle mainBundle] pathForResource:fragmentShaderFilename ofType:@"fsh"];
    NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragmentShaderPathname encoding:NSUTF8StringEncoding error:nil];

    if (!(self = [self initWidthFragementShaderString:fragmentShaderString]))
    {
        return nil;
    }
    
    return self;
}

- (instancetype)initWithVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fShaderString {
    self = [super init];
    if (self) {
        _updateTargetsSemaphore = dispatch_semaphore_create(0);
        dispatch_semaphore_signal(_updateTargetsSemaphore);
        self.mousePosition = CGSizeMake(0.5, 0.5);
        runSynchronouslyOnVideoProcessingQueue(^{
            self->_renderProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:vertexShaderString fragmentShaderString:fShaderString];
            if (!self->_renderProgram.initialized) {
                [self->_renderProgram addAttribute:@"position"];
                [self->_renderProgram addAttribute:@"surfacePosAttrib"];
                if (![self->_renderProgram link]) {
                    NSString *progLog = [self->_renderProgram programLog];
                    NSLog(@"Program link log: %@", progLog);
                    NSString *fragLog = [self->_renderProgram fragmentShaderLog];
                    NSLog(@"Fragment shader compile log: %@", fragLog);
                    NSString *vertLog = [self->_renderProgram vertexShaderLog];
                    NSLog(@"Vertex shader compile log: %@", vertLog);
                    self->_renderProgram = nil;
                    NSAssert(NO, @"Filter shader link failed");
                }
            }
            self->_positionAttribute = [self->_renderProgram attributeIndex:@"position"];
            self->_surfacePosAttribute = [self->_renderProgram attributeIndex:@"surfacePosAttrib"];
            self->_timeUniform = [self->_renderProgram uniformIndex:@"time"];
            self->_resolutionUniform = [self->_renderProgram uniformIndex:@"resolution"];
            self->_mouseUniform = [self->_renderProgram uniformIndex:@"mouse"];
            [GPUImageContext setActiveShaderProgram:self->_renderProgram];
            glEnableVertexAttribArray(self->_positionAttribute);
            glEnableVertexAttribArray(self->_surfacePosAttribute);
        });
    }
    return self;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:(1.0/60) target:self selector:@selector(render) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)startRender {
    self.startTime = [NSDate date];
    // it seems inefficiency use dispatch_source_t
//    _timer = createDispatchTimer(50 * NSEC_PER_MSEC, [[GLSLSandboxContext sharedInstance] timeQueue], ^{
//        [weakSelf render];
//    });
//    dispatch_resume(self.timer);
    if (self.isRunning) return;
    self.isRunning = YES;
    [self.timer fire];
    return;
    // use while loop will crash sometimes
//    __weak typeof(self) weakSelf = self;
//    dispatch_async([[GLSLSandboxContext sharedInstance] timeQueue], ^{
//        NSTimeInterval startTime;
//        NSTimeInterval endTime;
//        NSTimeInterval delta;
//        while (self.isRunning) {
//            startTime = [[NSDate date] timeIntervalSince1970];
//            [weakSelf render];
//            endTime = [[NSDate date] timeIntervalSince1970];
//            delta = endTime - startTime;
//            if (delta * 1000 < 16.0) {
//                usleep((16.0 - delta * 1000) * 1000);
//            }
//        }
//    });
}

- (void)stopRender {
//    if (self.timer) {
//        dispatch_source_cancel(self.timer);
//        self.timer = nil;
//    }
    self.isRunning = NO;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)render {
    CGSize framebufferSize = self.framebufferSize;
    [GPUImageContext setActiveShaderProgram:_renderProgram];
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:framebufferSize onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    NSDate *now = [NSDate date];
    glUniform1f(_timeUniform, now.timeIntervalSince1970 - self.startTime.timeIntervalSince1970);
    glUniform2f(_resolutionUniform, framebufferSize.width, framebufferSize.height);
    glUniform2f(_mouseUniform, self.mousePosition.width, self.mousePosition.height);
    static const GLfloat squareVertices[] = {
        - 1.0, - 1.0,
        1.0, - 1.0,
        - 1.0, 1.0,
        
        1.0, - 1.0,
        1.0, 1.0,
        - 1.0, 1.0
    };
    glVertexAttribPointer(_positionAttribute, 2, GL_FLOAT, 0, 0, squareVertices);
    glDrawArrays(GL_TRIANGLES, 0, 6);
    [self notifyTargetsToUpdateWithFrameBufferSize:framebufferSize];
}

- (void)notifyTargetsToUpdateWithFrameBufferSize:(CGSize)size {
    if (dispatch_semaphore_wait(_updateTargetsSemaphore, DISPATCH_TIME_NOW) != 0) {
        return;
    }
    for (id<GPUImageInput> currentTarget in self->targets) {
        NSInteger indexOfObject = [self->targets indexOfObject:currentTarget];
        NSInteger textureIndexOfTarget = [[self->targetTextureIndices objectAtIndex:indexOfObject] integerValue];
        if (currentTarget != self.targetToIgnoreForUpdates) {
            // should set rotation to kGPUImageFlipVertical, otherwise image vertical flip
            [currentTarget setInputRotation:kGPUImageFlipVertical atIndex:textureIndexOfTarget];
            [currentTarget setInputSize:size atIndex:textureIndexOfTarget];
            [currentTarget setInputFramebuffer:self->outputFramebuffer atIndex:textureIndexOfTarget];
        }
    }
    // must unlock outputFramebuffer otherwise memory leak
    [self->outputFramebuffer unlock];
    for (id<GPUImageInput> currentTarget in self->targets) {
        NSInteger indexOfObject = [self->targets indexOfObject:currentTarget];
        NSInteger textureIndexOfTarget = [[self->targetTextureIndices objectAtIndex:indexOfObject] integerValue];
        if (currentTarget != self.targetToIgnoreForUpdates) {
            [currentTarget newFrameReadyAtTime:kCMTimeIndefinite atIndex:textureIndexOfTarget];
        }
    }
    dispatch_semaphore_signal(self->_updateTargetsSemaphore);
}

- (void)dealloc {
    [self stopRender];
}

@end
