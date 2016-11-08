//
//  OffscreenRenderer.m
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/26.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

#import "OffscreenRenderer.h"
#import <OpenGL/OpenGL.h>
#include <OpenGL/gl3.h>
#include <GLKit/GLKit.h>

static const size_t bytesPerPixel = 4;
static const size_t bitsPerPixel = 32;
static const size_t bitsPerComponent = 8;

static void rgbReleaseData( void *info, const void *data, size_t size )
{
    free((char *)data);
}

static CGDataProviderRef createRGBDataProvider( const char *bytes, size_t width, size_t height )
{
    CGDataProviderRef dataProvider = NULL;
    size_t imageDataSize = width*height*bytesPerPixel;
//    unsigned char *p;
    unsigned char *dataP = (unsigned char *)malloc(imageDataSize);
    if(dataP == NULL){
        return NULL;
    }
#if 0
    p = memcpy(dataP, bytes, imageDataSize);
#else
    for ( size_t i = 0; i < height; ++i) {
        memcpy( &dataP[i * width * bytesPerPixel],
               &bytes[(height-i-1) * width * bytesPerPixel],
               width * bytesPerPixel);
    }
#endif
    dataProvider = CGDataProviderCreateWithData(NULL, dataP,
                                                imageDataSize, rgbReleaseData);
    return dataProvider;
}

@implementation OffscreenRenderer

- (id)imageWithSize:(NSSize)size
{
    CGLContextObj ctx;
    CGLPixelFormatObj pix;
    GLint npix;

    CGLPixelFormatAttribute attribs[] = {
        kCGLPFAOpenGLProfile,
        (CGLPixelFormatAttribute)kCGLOGLPVersion_3_2_Core,
        0
    };

    CGLChoosePixelFormat(attribs, &pix, &npix);
    CGLCreateContext(pix, NULL, &ctx);
    CGLSetCurrentContext(ctx);

    printf("%s %s\n", glGetString(GL_RENDERER), glGetString(GL_VERSION));

    GLuint framebuffer, renderbuffer;
    GLuint depthbuffer = 0;
    GLenum status;
    // Set the width and height appropriately for your image
    GLuint width = size.width, height = size.height;
    //Set up a FBO with one renderbuffer attachment[
    assert(glGetError()==0);
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glGenRenderbuffers(1, &depthbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, depthbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT32F, width, height);
    glGenRenderbuffers(1, &renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, renderbuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA8, width, height);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthbuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, renderbuffer);

    status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE)
    {   // Handle errors
        assert(0);
    }
    assert(glGetError()==0);

    glViewport(0, 0, width, height);

    // Draw Begin
    glClearColor( 1,1,1,1 );
    glClearDepth( 1 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    SCNRenderer *renderer = [SCNRenderer rendererWithContext:ctx options:nil];
    renderer.autoenablesDefaultLighting = YES;
    renderer.scene = self.scene;
    if ( self.pointOfView == nil )
    {
        SCNNode *cameraNode = [SCNNode node];
        cameraNode.camera = [SCNCamera camera];
        SCNVector3 center;
        CGFloat radius;
        [self.scene.rootNode getBoundingSphereCenter:&center radius:&radius];
        center.z += radius*2;
        cameraNode.position = center;
        [renderer.scene.rootNode addChildNode:cameraNode];
        renderer.pointOfView = cameraNode;
    }
    [renderer renderAtTime:5];
    glFlush();
    // Draw End

    GLuint pbo_id;
    glGenBuffers(1, &pbo_id);

    glBindBuffer(GL_PIXEL_PACK_BUFFER, pbo_id);
    glBufferData(GL_PIXEL_PACK_BUFFER, width*height*4, 0, GL_DYNAMIC_READ);
    glBindBuffer(GL_PIXEL_PACK_BUFFER, 0);

    glReadBuffer(GL_COLOR_ATTACHMENT0);
    glBindBuffer(GL_PIXEL_PACK_BUFFER, pbo_id);

    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, 0);
//    GLubyte *ptr = glMapBufferRange(GL_PIXEL_PACK_BUFFER, 0, width*height*4, GL_MAP_READ_BIT);
    GLubyte *ptr = glMapBuffer(GL_PIXEL_PACK_BUFFER, GL_READ_ONLY);

    CGDataProviderRef provider = createRGBDataProvider( (const char *)ptr, width, height );

    glUnmapBuffer(GL_PIXEL_PACK_BUFFER);
    glBindBuffer(GL_PIXEL_PACK_BUFFER, 0);
    glDeleteBuffers(1, &pbo_id);

    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    // Delete the renderbuffer attachment
    glDeleteRenderbuffers(1, &renderbuffer);
    glDeleteRenderbuffers(1, &depthbuffer);
    glDeleteFramebuffers(1, &framebuffer);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef image = CGImageCreate(width,
                                     height,
                                     bitsPerComponent,
                                     bitsPerPixel,
                                     bytesPerPixel*width,
                                     colorSpace,
                                     kCGBitmapByteOrderDefault,
                                     provider,
                                     NULL,
                                     NO,
                                     kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    NSImage *result = [[NSImage alloc] initWithCGImage:image size:NSMakeSize(width, height)];
    CGImageRelease(image);

    return result;
}

@end

