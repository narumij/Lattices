//
//  SimdExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/05/31.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

func lookat( _ pos: double3, eye: double3, up: double3 ) -> double4x4 {
    return double4x4(
        SCNMatrix4FromGLKMatrix4(
            GLKMatrix4MakeLookAt(
                Float(eye.x), Float(eye.y), Float(eye.z),
                Float(pos.x), Float(pos.y), Float(pos.z),
                Float(up.x), Float(up.y), Float(up.z) )))
}

func translation( _ x: Double, _ y: Double, _ z: Double ) -> double4x4
{
    #if os(OSX)
        return double4x4(SCNMatrix4MakeTranslation(CGFloat(x), CGFloat(y), CGFloat(z)))
    #elseif os(iOS)
        assert(false)
        return double4x4()
    #endif
}

func rotation( _ angle: Double, _ x: Double, _ y: Double, _ z: Double ) -> double4x4
{
    #if os(OSX)
        return double4x4(SCNMatrix4MakeRotation(CGFloat(angle), CGFloat(x), CGFloat(y), CGFloat(z)))
    #elseif os(iOS)
        assert(false)
        return double4x4()
    #endif
}

