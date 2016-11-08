//
//  3DxEventDataExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/02.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

struct TDxRotate {

    var x: Double = 0
    var y: Double = 0
    var z: Double = 0

    init( x: Double, y: Double, z: Double ) {
        self.x = x
        self.y = y
        self.z = z
    }

    init( x: Int32, y: Int32, z: Int32 ) {
        self.x = Double(x)
        self.y = Double(y)
        self.z = Double(z)
    }

}

func negate( r: TDxRotate ) -> TDxRotate {
    return TDxRotate( x: -r.x, y: -r.y, z: -r.z )
}

func length( r: TDxRotate ) -> Double {
    return length( double3( r.x, r.y, r.z ) )
}

//func rotation( x x:)

extension TDxEventData {
    var t: SCNVector3 {
        return SCNVector3(CGFloat(-tx),CGFloat(tz),CGFloat(-ty))
    }
    var r: TDxRotate {
        return TDxRotate( x: -rx, y: rz, z: -ry )
    }

    func rotation( factor: Double ) -> double4x4 {
        let motion = [r.x*factor,r.y*factor,r.z*factor]
        let ca = cos( motion[2] );
        let sa = sin( motion[2] );
        let cb = cos( motion[1] );
        let sb = sin( motion[1] );
        let cc = cos( motion[0] );
        let sc = sin( motion[0] );
        var rotate = double4x4(matrix_identity_double4x4)
        rotate[0,0] = ca*cb;
        rotate[0,1] = sa*cb;
        rotate[0,2] = -sb;
        rotate[1,0] = -sa*cc+ca*sc*sb;
        rotate[1,1] = ca*cc+sa*sc*sb;
        rotate[1,2] = cb*sc;
        rotate[2,0] = sa*sc+ca*cc*sb;
        rotate[2,1] = -ca*sc+sa*cc*sb;
        rotate[2,2] = cb*cc;
        return rotate
    }

    func translate(factor:CGFloat) -> SCNVector3 {
        return t * SCNVector3(scalar:factor)
    }

    func orientation(factor:CGFloat) -> SCNQuaternion {
        return SCNQuaternion(SCNMatrix4(rotation(Double(factor))))
    }
}






