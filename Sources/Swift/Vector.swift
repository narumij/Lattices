//
//  Vector.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import simd

#if os(OSX)

    //    typealias FloatType = Double
    typealias Vector2 = double2
    typealias Vector3 = double3
    typealias Vector4 = double4

let Vector2Zero = Vector2(0)
let Vector3Zero = Vector3(0)
let Vector4Zero = Vector4(0)

#elseif os(iOS)

    //    typealias FloatType = Float
    typealias Vector2 = float2
    public typealias Vector3 = float3
    typealias Vector4 = float4

let Vector2Zero = Vector2(0)
let Vector3Zero = Vector3(0)
let Vector4Zero = Vector4(0)

#endif

extension Vector3 {

    init( _ int: Int ) {
        self.init( FloatType(int) )
    }

    init( _ v: vector_float3 ) {
        self.init()
        self.x = v.x
        self.y = v.y
        self.z = v.z
    }

    init( hex: String ) {
        let hex0 = hex.head(2)
        let hex1 = hex.tail(2).head(2)
        let hex2 = hex.tail(2).tail(2).head(2)
        let i0 = Int(hex0, radix: 16) ?? 0
        let i1 = Int(hex1, radix: 16) ?? 0
        let i2 = Int(hex2, radix: 16) ?? 0
        self.init( x: FloatType(i0)/255, y: FloatType(i1)/255, z: FloatType(i2)/255 )
    }

    init( fixedPoint8 x: Int, _ y: Int, _ z: Int ) {
        self.init( x: FloatType(x)/255, y: FloatType(y)/255, z: FloatType(z)/255 )
    }

}

extension Vector4 {

    init( _ int: Int ) {
        self.init( FloatType(int) )
    }

    init( _ v: vector_float4 ) {
        self.init()
        self.x = v.x
        self.y = v.y
        self.z = v.z
        self.w = v.w
    }

}

extension Vector3 : Equatable {
}

public func == ( left: Vector3, right: Vector3 ) -> Bool {
    return left.x == right.x && left.y == right.y && left.z == right.z
}

func != ( left: Vector3, right: Vector3 ) -> Bool {
    return !(left == right)
}

func =~( l:Vector3, r:Vector3) -> Bool {
//    return distance(l,r) < 0.001
    return all( abs(l-r) < Vector3( 0.001 ) )
}

func =~~( l:Vector3, r:Vector3) -> Bool {
//    return distance(l,r) < sqrt( FloatType.epsilon )
    return all( abs(l-r) < Vector3( sqrt(FloatType.epsilon) ) )
}

func !~~( l:Vector3, r:Vector3) -> Bool {
    return !( l =~~ r )
}

func distance(_ x: Vector3, _ y: Vector3) -> FloatType {
    return FloatType( simd.distance( x, y ) )
}

func angle0(_ from: Vector3, apex: Vector3, to: Vector3 ) -> FloatType {
    return acos(min(1.0,max(-1.0,dot(normalize(from-apex),normalize(to-apex)))))
}

func cosTheta(_ from: Vector3, apex: Vector3, to: Vector3 ) -> FloatType {
    let a = from - apex
    let b = to - apex
    return dot(a,b) / ( sqrt( dot(a,a) ) * sqrt( dot(b,b) ) )
}

func angle1(_ from: Vector3, apex: Vector3, to: Vector3 ) -> FloatType {
    return acos(max(-1,min(1,cosTheta(from,apex:apex,to:to))))
}
#if true
    func angle(_ from: Vector3, apex: Vector3, to: Vector3 ) -> FloatType {
        let a = from - apex
        let b = to - apex
        let cosTheta = dot(a,b) / ( length(a) * length(b) )
        return acos(max(-1,min(1,cosTheta)))
    }
#else
func angle(from: Vector3, apex: Vector3, to: Vector3 ) -> FloatType {
    return angle1(from,apex:apex,to:to)
}
#endif

func torsion(_ from: Vector3, apex1 r2: Vector3, apex2 r3: Vector3, to r4: Vector3 ) -> FloatType {
    let r1 = from
    let r21 = r2 - r1
    let r32 = r3 - r2
    let r43 = r4 - r3
    let theta123 = angle(r1,apex:r2,to:r3)
    let theta234 = angle(r2,apex:r3,to:r4)
    let d21 = distance(r2,r1)
    let d32 = distance(r3,r2)
    let d43 = distance(r4,r3)
    let torsion1234 = dot( cross( r21, r32 ), cross( r32, r43 ) ) / ( d21 * d32*d32 * d43 * sin(theta123) * sin(theta234) )
    return torsion1234
}

func translate( _ t: Vector3, factor: FloatType ) -> Vector3 {
    return t * Vector3( factor )
}

func rotation( _ r: Vector3, factor: FloatType ) -> Matrix4x4 {
    let motion = [ FloatType(r.x * factor), FloatType(r.y * factor), FloatType(r.z * factor) ]
    let ca = cos( motion[2] );
    let sa = sin( motion[2] );
    let cb = cos( motion[1] );
    let sb = sin( motion[1] );
    let cc = cos( motion[0] );
    let sc = sin( motion[0] );
    var rotate = Matrix4x4Identity
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

func toTuple( _ v: Vector3 ) -> (FloatType,FloatType,FloatType) {
    return (v.x,v.y,v.z)
}

func toTuple( _ v: Vector4 ) -> (FloatType,FloatType,FloatType,FloatType) {
    return (v.x,v.y,v.z,v.w)
}



