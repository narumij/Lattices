//
//  Matrix.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import simd

#if os(OSX)

    //    typealias FloatType = Double
    typealias Matrix4x4 = double4x4
    typealias Matrix3x3 = double3x3

let Matrix4x4Identity = Matrix4x4(matrix_identity_double4x4)

#elseif os(iOS)

    //    typealias FloatType = Float
    public typealias Matrix4x4 = float4x4
    public typealias Matrix3x3 = float3x3

public let Matrix3x3Identity = Matrix3x3(matrix_identity_float3x3)
public let Matrix4x4Identity = Matrix4x4(matrix_identity_float4x4)
//let Matrix4x4Zero = Matrix4x4(0.0)
    
#endif

func all( _ boolArray: [Bool] ) -> Bool {
    return boolArray.reduce(true) { $0 && $1 }
}

func any( _ boolArray: [Bool] ) -> Bool {
    return boolArray.reduce(false) { $0 || $1 }
}

extension Matrix4x4: Equatable {
}

public func == ( left: Matrix4x4, right: Matrix4x4 ) -> Bool {
    return all([0,1,2,3].map({(left[$0],right[$0])}).map({all($0.0==$0.1)}))
}
func =~~ ( left: Matrix4x4, right: Matrix4x4 ) -> Bool {
    return all([0,1,2,3].map({(left[$0],right[$0])}).map({all($0.0=~~$0.1)}))
}

func == ( left: Matrix3x3, right: Matrix3x3 ) -> Bool {
    return all([0,1,2].map({(left[$0],right[$0])}).map({all($0.0==$0.1)}))
}
func =~~ ( left: Matrix3x3, right: Matrix3x3 ) -> Bool {
    return all([0,1,2].map({(left[$0],right[$0])}).map({all($0.0=~~$0.1)}))
}

extension Matrix4x4 {
    var matrix3x3 : Matrix3x3 {
        var m = Matrix3x3()
        for i in 0..<3 {
            for j in 0..<3 {
                m[i,j] = self[i,j]
            }
        }
        return m
    }
    var translatePart : Vector3 {
        get {
            return self[3].xyz
//            return Vector3(self[3,0],self[3,1],self[3,2])
        }
        set(v) {
            self[3,0] = v.x
            self[3,1] = v.y
            self[3,2] = v.z
        }
    }
    var rotatePart : Matrix3x3 {
        get {
            return matrix3x3
        }
        set(m) {
            for i in 0..<3 {
                for j in 0..<3 {
                    self[i,j] = m[i,j]
                }
            }
        }
    }
}

extension Matrix3x3 {
    var rows: [Vector3] {
        let trans = transpose
        return [0,1,2].map{ Vector3(trans[$0]) }
    }
    var columns: [Vector3] {
        return [0,1,2].map{ Vector3(self[$0]) }
    }
}

func Matrix4x4From3x3( _ m: Matrix3x3 ) -> Matrix4x4 {
    var m4 = Matrix4x4Identity
    for i in 0..<3 {
        for j in 0..<3 {
            m4[i,j] = m[i,j]
        }
    }
    return m4
}



