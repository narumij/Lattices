//
//  Matrix+SceneKit.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

func orientation( _ r: Vector3, factor: FloatType) -> SCNQuaternion {
    return SCNQuaternion(SCNMatrix4(rotation(r,factor:factor)))
}

extension SCNMatrix4 {
    var matrix4x4 : Matrix4x4 {
        var m = Matrix4x4()
        for i in 0..<4 {
            for j in 0..<4 {
                m[i,j] = self[i,j]
            }
        }
        return m
    }
}
