//
//  Eigen.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/19.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Accelerate
import simd


struct Float3x3Eigen {

    var matrix3x3 : Matrix3x3
    var vector3 : Vector3

    init(ptr:UnsafeMutablePointer<__CLPK_real>) {
        let col0 = vector_float3(ptr.advanced(by: 0).pointee,
                                 ptr.advanced(by: 1).pointee,
                                 ptr.advanced(by: 2).pointee)
        let col1 = vector_float3(ptr.advanced(by: 3).pointee,
                                 ptr.advanced(by: 4).pointee,
                                 ptr.advanced(by: 5).pointee)
        let col2 = vector_float3(ptr.advanced(by: 6).pointee,
                                 ptr.advanced(by: 7).pointee,
                                 ptr.advanced(by: 8).pointee)

        matrix3x3 = Matrix3x3( matrix_float3x3( columns: ( col0, col1, col2 ) ) )
        vector3 = Vector3( ptr.advanced(by:  9).pointee,
                           ptr.advanced(by: 10).pointee,
                           ptr.advanced(by: 11).pointee )
    }

    init(_ o: Matrix3x3,_ v: Vector3 ) {
        matrix3x3 = o
        vector3 = v
    }

    init(_ m : matrix_float3x3 )
    {
        var jobz : CChar = 0x56                // V 固有ベクトルも計算する
        var uplo : CChar = 0x55                // U 上三角部分を使用。ただし列優先。
        var n : __CLPK_integer = 3             // matrixの行数
        var lda : __CLPK_integer = n           // matrixのleading dimension
        var lwork : __CLPK_integer = 27
        var info : __CLPK_integer = 0          // ssyev_()の処理結果
        let work = UnsafeMutablePointer<__CLPK_real>.allocate(capacity: Int(lwork) )
        let e = UnsafeMutablePointer<__CLPK_real>.allocate(capacity: 12)

        e.advanced(by: 0).pointee = m.columns.0[0]
        e.advanced(by: 1).pointee = m.columns.0[1]
        e.advanced(by: 2).pointee = m.columns.0[2]
        e.advanced(by: 3).pointee = m.columns.1[0]
        e.advanced(by: 4).pointee = m.columns.1[1]
        e.advanced(by: 5).pointee = m.columns.1[2]
        e.advanced(by: 6).pointee = m.columns.2[0]
        e.advanced(by: 7).pointee = m.columns.2[1]
        e.advanced(by: 8).pointee = m.columns.2[2]

        ssyev_(&jobz,
               &uplo,
               &n,
               e,
               &lda,
               e.advanced(by: 9),
               work,
               &lwork,
               &info)

        if info != 0 {
            self.init( Matrix3x3Identity, Vector3Zero )
        }
        else {
            self.init(ptr:e)
        }

        work.deallocate(capacity: Int(lwork))
        e.deallocate(capacity: 12)
    }

    static let identity = Float3x3Eigen( Matrix3x3Identity, Vector3Zero )
    
    fileprivate var det : FloatType {
        return matrix_determinant(matrix3x3.cmatrix)
    }

    var matrix4x4 : Matrix4x4 {
        let m = matrix3x3
        return Matrix4x4(
            matrix_float4x4(columns: (
                vector_float4( m[0][0], m[0][1], m[0][2],  0.0 ),
                vector_float4( m[1][0], m[1][1], m[1][2],  0.0 ),
                vector_float4( m[2][0], m[2][1], m[2][2],  0.0 ),
                vector_float4(     0.0,     0.0,     0.0, det < 0 ? -1 : 1 )
            ) ) )
    }

    var ellipsoidScale : Vector3 {
        return simd.vector3( sqrt( vector3.x ), sqrt( vector3.y ), sqrt( vector3.z ) )
    }
    
}


