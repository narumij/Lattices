//
//  CrystalMagnet.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/25.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

#if false
func MxyzParse( mxyz: String ) -> Matrix4x4 {
    return XyzParse( mxyz.stringByReplacingOccurrencesOfString( "m", withString: "" ) )
}

// magnet operationとmagnet centeringがある。この違いが分からない。
struct CrystalSymopMagn {
    var detP:Double = 1
    var momentMatrix:Matrix4x4 = Matrix4x4Identity
    init( XYZR: String, MXYZ: String, index: Int ){
        let components = XYZR.componentsSeparatedByString(",")
        let xyzPart = [components[0],components[1],components[2]]
        let xyz = xyzPart.reduce("") { (result, str) -> String in
            switch result {
            case "":
                return str
            default:
                return result + "," + str
            }
        }
        super.init(XYZ: xyz, index: index)
        self.detP = (components[3] as NSString).doubleValue
        self.momentMatrix = MxyzParse( MXYZ )
    }
}

struct CrystalAtomSiteMoment {
    var label : String
    var crystalAxis : Vector3 = vector3(1, 0, 0)
    var normal : Vector3 {
        return crystalAxis.normal
    }
    init( label: String, axisX: FloatType, axisY: FloatType, axisZ: FloatType ) {
        self.label = label
        self.crystalAxis = vector3( axisX, axisY, axisZ)
    }
}

struct CrystalSymopKvec {
    var index : Int = 0
    var xyz : Vector3 = vector3(0,0,0)
}
#endif

