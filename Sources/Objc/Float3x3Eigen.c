//
//  Float3x3Eigen.c
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

#include "Float3x3Eigen.h"
#include <stdio.h>
#include <stdlib.h>

Float3x3Eigen_t Float3x3EigenIdentity = {
    { 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0 },
    { 0.0, 0.0, 0.0 }
};;

static Float3x3Eigen_t Prepare( matrix_float3x3 m ) {
    Float3x3Eigen_t eigen = Float3x3EigenIdentity;
#if 1
    eigen.orth[0] = m.columns[0][0];
    eigen.orth[1] = m.columns[0][1];
    eigen.orth[2] = m.columns[0][2];
    eigen.orth[3] = m.columns[1][0];
    eigen.orth[4] = m.columns[1][1];
    eigen.orth[5] = m.columns[1][2];
    eigen.orth[6] = m.columns[2][0];
    eigen.orth[7] = m.columns[2][1];
    eigen.orth[8] = m.columns[2][2];
#endif
    return eigen;
}

Float3x3Eigen_t Float3x3Eigen( matrix_float3x3 m )
{
    typedef __CLPK_integer integer;
    char jobz = 'V';                // 固有ベクトルも計算する
    char uplo ='U';                 // 上三角部分を使用。ただし列優先。
    integer n = 3;                  // matrixの行数
    integer lda = n;                // matrixのleading dimension
    integer lwork = 27;
    integer info = 0;               // dsyev_()の処理結果
    Float3x3Eigen_t eigen = Prepare(m);
    float *work = malloc(sizeof(float)*lwork);
    ssyev_(&jobz,
           &uplo,
           &n,
           //		   &eigen.orth.m[0],
           &eigen.orth[0],
           &lda,
           &eigen.vec[0],
           work,
           &lwork,
           &info);
    free(work);
    if ( info ) {
//        printf("eigen failure\n");
        return Float3x3EigenIdentity;
    }
//    printf("eigen success %f %f %f\n",eigen.vec[0],eigen.vec[1],eigen.vec[2]);
    return eigen;
}




