//
//  CrystalCellExtension.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/21.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit


extension CrystalCell_t {
//    var a: FloatType { return lengthA }
//    var b: FloatType { return lengthB }
//    var c: FloatType { return lengthC }
//    var alpha: FloatType { return angleAlpha.toRadian }
//    var beta: FloatType { return angleBeta.toRadian }
//    var gamma: FloatType { return angleGamma.toRadian }
//    var aStar: FloatType { return b * c * sin(alpha) / v }
//    var bStar: FloatType { return c * a * sin(beta) / v }
//    var cStar: FloatType { return a * b * sin(gamma) / v }
//    fileprivate lazy var sinAlpha: FloatType = { sin( self.alpha ) }()
//    fileprivate lazy var cosAlpha: FloatType { return cos( alpha ) }
//    fileprivate lazy var sinBeta:  FloatType { return sin( beta ) }
//    fileprivate lazy var cosBeta:  FloatType { return cos( beta ) }
//    fileprivate lazy var sinGamma: FloatType { return sin( gamma ) }
//    fileprivate lazy var cosGamma: FloatType { return cos( gamma ) }

//    fileprivate var cosAlphaStar : FloatType {
//        return (cosBeta * cosGamma - cosAlpha) / (sinBeta * sinGamma)
//    }

//    var v : FloatType {
////        return a * b * c *
////            sqrt( 1.0 - cosAlpha * cosAlpha - cosBeta * cosBeta - cosGamma * cosGamma
////                + 2.0 * cosAlpha * cosBeta * cosGamma )
//        let s = sqrt( 1.0 - cosAlpha * cosAlpha - cosBeta * cosBeta - cosGamma * cosGamma
//            + 2.0 * cosAlpha * cosBeta * cosGamma )
//        return a * b * c * s
//    }

//    var aVector : Vector3 { return vector3( a , 0, 0 ) }
//    var bVector : Vector3 { return vector3( b * cosGamma, b * sinGamma, 0) }

//    #if false
//    var cVector : Vector3 {
//        let cy = ( cosAlpha - cosBeta * cosGamma ) / sinGamma
//        return vector3( c * cosBeta,
//                           c * cy,
//                           c * sqrt( 1.0 - cosBeta * cosBeta - cy * cy ) ) }
//    #else
//    var cVector : Vector3 {
//        return vector3( c * cosBeta, -c * sinBeta * cosAlphaStar, 1.0 / cStar )
//    }
//    #endif

    var cartnCenter : Vector3 {
        return ( aVector + bVector + cVector ) * vector3(0.5)
    }

    var direction100 : Vector3 {
        return normalize(aVector)
    }

    var direction010 : Vector3 {
        return normalize(bVector)
    }

    var direction001 : Vector3 {
        return normalize(cVector)
    }

    var direction111 : Vector3 {
        return normalize(aVector+bVector+cVector)
    }

    var normal100 : Vector3 {
        return normalize(cross(direction010,direction001))
    }

    var normal010 : Vector3 {
        return normalize(cross(direction100,direction001))
    }

    var normal001 : Vector3 {
        return normalize(cross(direction100,direction010))
    }

    var normal111 : Vector3 {
        return normalize(cross(normalize(aVector-bVector),normalize(cVector-bVector)))
    }

    func distance( _ v1: Vector3, _ v2: Vector3 ) -> FloatType {

        let ( x12, y12, z12 ) = toTuple( v2-v1 )
        #if false
        return sqrt(
            x12 * x12 * a * a
                + y12 * y12 * b * b
                + z12 * z12 * c * c
                + 2.0 * x12 * y12 * a * b * cos( gamma )
                + 2.0 * x12 * z12 * a * c * cos( beta )
                + 2.0 * y12 * z12 * b * c * cos( alpha ) )
        #else
            return sqrt(
                x12 * x12 * a * a
                    + y12 * y12 * b * b
                    + z12 * z12 * c * c
                    + 2.0 * x12 * y12 * a * b * cosGamma
                    + 2.0 * x12 * z12 * a * c * cosBeta
                    + 2.0 * y12 * z12 * b * c * cosAlpha )
        #endif
    }

    func distanceError( _ v1: ( fract: Vector3, su:Vector3 ), v2: ( fract: Vector3, su: Vector3 ) ) -> FloatType {
        let (sx1,sy1,sz1) = toTuple(v1.su)
        let (sx2,sy2,sz2) = toTuple(v2.su)
        let (x12,y12,z12) = toTuple(v1.fract-v2.fract)
        let d12 = distance(v1.fract, v2.fract)
        let line1 = ( sx1 + sx2 ) * pow( x12*a + y12*b*cos(gamma) + z12*c*cos(beta)  / d12, 2 )
        let line2 = ( sy1 + sy2 ) * pow( y12*b + x12*a*cos(gamma) + z12*c*cos(alpha) / d12, 2 )
        let line3 = ( sz1 + sz2 ) * pow( z12*c + x12*a*cos(beta)  + y12*b*cos(alpha) / d12, 2 )
        return line1+line2+line3
    }

    func angle( _ r1: Vector3, apexFract r2: Vector3, toFract r3: Vector3 ) -> FloatType {
        let d12 = distance( r1, r2 )
        let d23 = distance( r2, r3 )
        #if true
            let (x21,y21,z21) = toTuple(r1-r2)
            let (x23,y23,z23) = toTuple(r3-r2)
            let aa = a*a
            let bb = b*b
            let cc = c*c
            let ab = a*b
            let ac = a*c
            let bc = b*c
            var cosTheta =
                ( x21*x23*aa + y21*y23*bb + z21*z23*cc
                    + (x21*y23 + y21*x23) * ab * cos( gamma )
                    + (x21*z23 + z21*x23) * ac * cos( beta )
                    + (y21*z23 + z21*y23) * bc * cos( alpha ) ) / ( d12 * d23 )
        #else
            let d13 = distance( r1, r3 )
            var cosTheta = ( d12*d12 + d23*d23 - d13*d13 ) / ( 2 * d12 * d23 )
        #endif
        cosTheta = max(-1,min(1,cosTheta))
        return acos( cosTheta )
    }

}









