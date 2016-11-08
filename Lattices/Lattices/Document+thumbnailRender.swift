//
//  Document+thumbnailRender.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/16.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

extension Document {

    var backgroundColor: UIColor {
        return UIColor.white
    }

    func setSceneOnRenderer(_ renderer: SCNSceneRenderer) {
        renderer.scene = crystal.scene
        renderer.pointOfView = crystal.camera.pointOfView
    }

    func renderThumbnailOfSize(_ size: CGSize) -> UIImage {
        /*
         We want to create a thumbnail while running on the background thread.
         The obvious choice would be to use `SCNView`'s snapshot method, but we
         have a problem: we don't have an `SCNView`, and we can't create a view
         while on the background thread. Instead of eagerly creating a view
         that is only used for snapshotting, we create our own renderer, frame,
         color and depth buffers, and then render and read the pixels into a
         `CGImage`.
         */

        let width = Int(size.width)
        let height = Int(size.height)

        // Create and setup a context and renderer.
        let glContext = EAGLContext(api: .openGLES2)!
        let renderer = SCNRenderer(context: glContext, options: [:])
        renderer.autoenablesDefaultLighting = true
        setSceneOnRenderer(renderer)

        // Make the context current.
        let previousContext = EAGLContext.current()
        defer {
            EAGLContext.setCurrent(previousContext)
        }
        EAGLContext.setCurrent(glContext)

        // Create our frame buffer.
        var frameBuffer: GLuint = 0
        glGenFramebuffers(1, &frameBuffer)
        defer {
            glDeleteFramebuffers(1, &frameBuffer)
        }
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), frameBuffer)

        // Create a color buffer (RGBA) and attach it to our frame buffer.
        var colorBuffer: GLuint = 0
        glGenRenderbuffers(1, &colorBuffer)
        defer {
            glDeleteRenderbuffers(1, &colorBuffer)
        }
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), colorBuffer)

        // RGBA.
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_RGBA8), GLsizei(width), GLsizei(height))
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), colorBuffer)

        // Create a depth buffer and attach it to out frame buffer.
        var depthBuffer: GLuint = 0
        glGenRenderbuffers(1, &depthBuffer)
        defer {
            glDeleteRenderbuffers(1, &depthBuffer)
        }
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), depthBuffer)
        glRenderbufferStorage(GLenum(GL_RENDERBUFFER), GLenum(GL_DEPTH_COMPONENT24), GLsizei(width), GLsizei(height))
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_DEPTH_ATTACHMENT), GLenum(GL_RENDERBUFFER), depthBuffer)

        // Set the background color.
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        backgroundColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        glClearColor(Float(red), Float(green), Float(blue), Float(alpha))

        // Set our viewport, clear out the buffers and render.
        glViewport(0, 0, GLsizei(width), GLsizei(height))
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
        renderer.render(atTime: 0.0)

        // Read the contents of our framebuffer into an `NSMutableData`.

        // RGBA.
        let componentsPerPixel = 4

        // 8-bit.
        let bitsPerComponent = 8

        let imageBits = NSMutableData(length: width * height * componentsPerPixel)!
        glReadPixels(0, 0, GLsizei(width), GLsizei(height), GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), imageBits.mutableBytes)

        // Create a `CGImage` off that data.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let dataProvider = CGDataProvider(data: imageBits)

        let cgBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue)
        let cgImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: componentsPerPixel * bitsPerComponent, bytesPerRow: width * componentsPerPixel, space: colorSpace, bitmapInfo: cgBitmapInfo, provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: .defaultIntent)!

        // Flip the image to match our Editor view's coordinate system.
        let image = UIImage(cgImage: cgImage)

        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)

        let context = UIGraphicsGetCurrentContext()

        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: image.size.height)

        context!.concatenate(flipVertical)

        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: imageRect)

        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return flippedImage!
    }
}
