//
//  CrystalCell+Matrix.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/05.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension CrystalCell_t {
    
    var matrix4x4 : Matrix4x4 {
        #if false
            return transpose(matrix4x4_drawxlt)
        #else
            return matrix4x4_std
        #endif
    }

    var matrix3x3 : Matrix3x3 {
        #if false
            return transpose(matrix3x3_drawxlt)
        #else
            return matrix3x3_std
        #endif
    }

    fileprivate var identity: Matrix4x4 {
        return Matrix4x4Identity
    }

    fileprivate var matrix4x4_std : Matrix4x4 {
        let m3 = matrix3x3_std
        var m4 = Matrix4x4()
        for i in 0..<3 {
            for j in 0..<3 {
                m4[i,j] = m3[i,j]
            }
        }
        m4[3,3] = 1
        return m4
    }

    fileprivate var matrix3x3_std : Matrix3x3 {
        #if true
            var m3 = Matrix3x3()
            m3[0] = aVector
            m3[1] = bVector
            m3[2] = cVector
            return m3
        #else
            return Matrix3x3(
                [ aVector,
                    bVector,
                    cVector ] )
        #endif
    }

    fileprivate var matrix4x4_drawxlt : Matrix4x4 {
        let m3 = matrix3x3_drawxlt
        var m4 = Matrix4x4Identity
        for i in 0..<3 {
            for j in 0..<3 {
                m4[i,j] = m3[i,j]
            }
        }
        return m4
    }

    fileprivate var matrix3x3_drawxlt : Matrix3x3 {
        let lat_con : [FloatType] = [ a, b, c ]
        var b_mat = Matrix3x3(0.0)
        b_mat[0][0] = 1.0;
        let csal = cos(alpha);
        let csbe = cos(beta);
        let csga = cos(gamma);
        let snga = sin(gamma);
        b_mat[0,1] = csga;
        b_mat[1,1] = snga;
        b_mat[0,2] = csbe;
        b_mat[1,2] = (csal - csbe * csga) / snga
        b_mat[2,2] = sqrt ( 1.0 - b_mat[0,2] * b_mat[0,2] - b_mat[1,2] * b_mat[1,2] )
        for i in 0...2 {
            for j in 0...2 {
                b_mat[j][i] *= lat_con[i];
            }
        }
        return b_mat;
    }

    func toCartn( fract: Vector3 ) -> Vector3 {
        return (matrix4x4 * vector4( fract, 1 ) ).xyz
    }
}



