//
//  FloatNExtension.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/07.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import simd

func vector2( _ __scalar: Float ) -> vector_float2 {
    return vector2(__scalar,__scalar)
}
func vector3( _ __scalar: Float ) -> vector_float3 {
    return vector3(__scalar,__scalar,__scalar)
}
func vector4( _ __scalar: Float ) -> vector_float4 {
    return vector4(__scalar,__scalar,__scalar,__scalar)
}

extension float3 {
//    func equiv(v:float3) -> Bool {
//        // warning 書き直す
//        return distance(self,v) < 0.001
//    }
    var show:String {
        return "x :"+x.description+" y:"+y.description+" z:"+z.description
    }
}

extension float3 {
    var xy : float2 {
        return float2(x,y)
    }
    var yx : float2 {
        return float2(y,x)
    }
}

extension float4 {
    var xyz:float3 {
        return float3(x, y, z)
    }
    var show : String {
        return "( "+x.description+", "+y.description+", "+z.description+", "+w.description+" )"
    }
}

extension matrix_float3x3 {
    init(_ m: float3x3 ) {
        self.init(columns: ( m[0], m[1], m[2] ) )
    }
}

extension matrix_float4x4 {
    init(_ m: float4x4 ) {
        self.init(columns: ( m[0], m[1], m[2], m[3] ) )
    }
}

extension float3x3 {
    var determinant : Float {
        return matrix_determinant(cmatrix)
    }
}

extension float4x4 {
    var determinant : Float {
        return matrix_determinant(cmatrix)
    }
}

func invert( _ m: float3x3 ) -> float3x3
{
    return m.inverse
}

func invert( _ m: float4x4 ) -> float4x4
{
    return m.inverse
}

func transpose( _ m: float3x3 ) -> float3x3
{
    return m.transpose
}

func transpose( _ m: float4x4 ) -> float4x4
{
    return m.transpose
}

func =~~( l: float2, r: float2 ) -> Bool2 {
    return ( l.x=~~r.x, l.y=~~r.y )
}

func =~~( l: float3, r: float3 ) -> Bool3 {
    return ( l.x=~~r.x, l.y=~~r.y, l.z=~~r.z )
}

func =~~( l: float4, r: float4 ) -> Bool4 {
    return ( l.x=~~r.x, l.y=~~r.y, l.z=~~r.z, l.w=~~r.w )
}

