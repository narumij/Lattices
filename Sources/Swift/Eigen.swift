//
//  Eigen.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/19.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

// リリースビルドで不具合を起こすので、当分凍結とする。

/*
import Accelerate
import simd

struct Float3x3Eigen_t {
    typealias Real_t = __CLPK_real
    var orth : ( Real_t,Real_t,Real_t, Real_t,Real_t,Real_t, Real_t,Real_t,Real_t )
    var vec : ( Real_t,Real_t,Real_t )
}

let Float3x3EigenIdentity = Float3x3Eigen_t( orth: (1,0,0,0,1,0,0,0,1), vec: (0,0,0) )

private func Prepare( m: matrix_float3x3 ) -> Float3x3Eigen_t {
    var eigen = Float3x3EigenIdentity
    eigen.orth.0 = m.columns.0[0];
    eigen.orth.1 = m.columns.0[1];
    eigen.orth.2 = m.columns.0[2];
    eigen.orth.3 = m.columns.1[0];
    eigen.orth.4 = m.columns.1[1];
    eigen.orth.5 = m.columns.1[2];
    eigen.orth.6 = m.columns.2[0];
    eigen.orth.7 = m.columns.2[1];
    eigen.orth.8 = m.columns.2[2];
    return eigen;
}

func Float3x3Eigen( m : matrix_float3x3 ) -> Float3x3Eigen_t
{
    typealias integer = __CLPK_integer
    var jobz : CChar = 0x56                // V 固有ベクトルも計算する
    var uplo : CChar = 0x55                // U 上三角部分を使用。ただし列優先。
    var n : integer = 3                  // matrixの行数
    var lda : integer = n                // matrixのleading dimension
    var lwork : integer = 27
    var info : integer = 0               // dsyev_()の処理結果
    var eigen : Float3x3Eigen_t = Prepare(m)
    let work = UnsafeMutablePointer<Float>( malloc( sizeof(Float) * Int(lwork) ) )
    ssyev_(&jobz,
           &uplo,
           &n,
           &eigen.orth.0,
           &lda,
           &eigen.vec.0,
           work,
           &lwork,
           &info)
    free(work)
    return info != 0 ? Float3x3EigenIdentity : eigen
}
*/
