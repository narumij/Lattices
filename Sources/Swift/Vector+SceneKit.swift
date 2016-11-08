//
//  Vector+SceneKit.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

extension Vector3 {
    var scn: SCNVector3 {
        return SCNVector3(self)
    }
}

func * ( l: SCNQuaternion, r: Vector3 ) -> Vector3 {
    return Vector3( l * SCNVector3(r) )
}
