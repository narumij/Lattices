//
//  doubleNExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import simd

func vector2( _ __scalar: Double ) -> vector_double2 {
    return vector2(__scalar,__scalar)
}
func vector3( _ __scalar: Double ) -> vector_double3 {
    return vector3(__scalar,__scalar,__scalar)
}
func vector4( _ __scalar: Double ) -> vector_double4 {
    return vector4(__scalar,__scalar,__scalar,__scalar)
}

extension double3 {
    var xy : double2 {
        return double2(x,y)
    }
    var yx : double2 {
        return double2(y,x)
    }
}

extension double3 {
    var show:String {
        return "x :"+x.description+" y:"+y.description+" z:"+z.description
    }
}

extension double4 {
    init(_ xyz:double3, _ w:Double ) {
        self.init( xyz, w )
    }
    var xyz:double3 {
        return double3(x, y, z)
    }
    var show : String {
        return "( "+x.description+", "+y.description+", "+z.description+", "+w.description+" )"
    }
}

extension matrix_double3x3 {
    init(_ m: double3x3 ) {
        self.init(columns: ( m[0], m[1], m[2] ) )
    }
}

extension matrix_double4x4 {
    init(_ m: double4x4 ) {
        self.init(columns: ( m[0], m[1], m[2], m[3] ) )
    }
}

extension double3x3 {
    var determinant : Double {
        return matrix_determinant(cmatrix)
    }
}

extension double4x4 {
    var determinant : Double {
        return matrix_determinant(cmatrix)
    }
}

func invert( _ m: double3x3 ) -> double3x3
{
    return m.inverse
}

func invert( _ m: double4x4 ) -> double4x4
{
    return m.inverse
}

func transpose( _ m: double3x3 ) -> double3x3
{
    return m.transpose
}

func transpose( _ m: double4x4 ) -> double4x4
{
    return m.transpose
}

func =~~( l: double2, r: double2 ) -> Bool2 {
    return ( l.x=~~r.x, l.y=~~r.y )
}

func =~~( l: double3, r: double3 ) -> Bool3 {
    return ( l.x=~~r.x, l.y=~~r.y, l.z=~~r.z )
}

func =~~( l: double4, r: double4 ) -> Bool4 {
    return ( l.x=~~r.x, l.y=~~r.y, l.z=~~r.z, l.w=~~r.w )
}



