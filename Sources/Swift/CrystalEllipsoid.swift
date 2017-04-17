//
//  CrystalEllipsoid.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit
import Accelerate

struct Iso {
    var isoOrEquiv : FloatType
    //    init( equiv value: String ) {
    //        isoOrEquiv = value.floatTypeValue
    //    }
}

struct Aniso {
    var _11:FloatType
    var _22:FloatType
    var _33:FloatType
    var _12:FloatType
    var _13:FloatType
    var _23:FloatType
}

typealias Biso_t = Iso
typealias Uiso_t = Iso
typealias Bani_t = Aniso
typealias Uani_t = Aniso

extension Aniso {
    init( b bValues: [CrystalAtomSiteAniso_t.CIFTag:String] ) {
        _11 = bValues[.B11]?.floatTypeValue ?? 0.0
        _22 = bValues[.B22]?.floatTypeValue ?? 0.0
        _33 = bValues[.B33]?.floatTypeValue ?? 0.0
        _12 = bValues[.B12]?.floatTypeValue ?? 0.0
        _13 = bValues[.B13]?.floatTypeValue ?? 0.0
        _23 = bValues[.B23]?.floatTypeValue ?? 0.0
    }
}

extension Aniso {
    init( u uValues: [CrystalAtomSiteAniso_t.CIFTag:String] ) {
        _11 = uValues[.U11]?.floatTypeValue ?? 0.0
        _22 = uValues[.U22]?.floatTypeValue ?? 0.0
        _33 = uValues[.U33]?.floatTypeValue ?? 0.0
        _12 = uValues[.U12]?.floatTypeValue ?? 0.0
        _13 = uValues[.U13]?.floatTypeValue ?? 0.0
        _23 = uValues[.U23]?.floatTypeValue ?? 0.0
    }
}

private var anisoTransformCoef : FloatType = 8.0 * pow( FloatType.pi, 2.0 )

private func aniTrans( _ val0 : FloatType,_ val1 : FloatType ) -> FloatType {
    return anisoTransformCoef * val0 * val1
}

private func aniTrans( _ value: FloatType ) -> FloatType {
    return aniTrans( value, value )
}

extension CrystalCell_t {

    func UisoFromBiso( _ B : Biso_t ) -> Uiso_t {
        return Uiso_t(isoOrEquiv: B.isoOrEquiv / anisoTransformCoef )
    }

    func UaniFromBani( _ B : Bani_t ) -> Uani_t {
        return Uani_t(_11: B._11 / aniTrans( aStar ),
                      _22: B._22 / aniTrans( bStar ),
                      _33: B._33 / aniTrans( cStar ),
                      _12: B._12 / aniTrans( aStar, bStar ),
                      _13: B._13 / aniTrans( aStar, cStar ),
                      _23: B._23 / aniTrans( bStar, cStar ) )
    }

    var dMatrix : Matrix3x3 {
        var d = Matrix3x3( 0.0 )
        let a = transpose( matrix3x3 )
        var aVec = vector3( aStar, bStar, cStar )
        for i in 0..<3 {
            for j in 0..<3 {
                d[i,j] = a[i,j] * aVec[j]
            }
        }
        return d
    }

    func CartUFromUani( _ U : Uani_t ) -> CartU_t {
        var Uc = Matrix3x3(0.0)
        let D = dMatrix
        let U = U.matrix3x3
        for j in 0..<3 {
            for l in 0..<3 {
                for m in 0..<3 {
                    for n in 0..<3 {
                        Uc[j,l] += D[j,m] * D[l,n] * U[m,n]
                    }
                }
            }
        }
        return Uc
    }
}


typealias CartU_t = Matrix3x3


extension Uiso_t {
    var CartU : CartU_t {
        return CartU_t( diagonal: vector3( isoOrEquiv ) )
    }
}


extension Uani_t {
    var matrix3x3 : Matrix3x3 {
        var m = Matrix3x3()
        m[0,0] = _11; m[1,1] = _22; m[2,2] = _33
        m[0,1] = _12; m[1,0] = _12
        m[0,2] = _13; m[2,0] = _13
        m[1,2] = _23; m[2,1] = _23
        return m
    }
}



















