//
//  Float3x3Eigen.h
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

#ifndef Float3x3Eigen_h
#define Float3x3Eigen_h

#include <simd/simd.h>
#include <Accelerate/Accelerate.h>

typedef struct Float3x3Eigen_t {
    __CLPK_real orth[9];
    __CLPK_real vec[3];
} Float3x3Eigen_t;

extern Float3x3Eigen_t Float3x3EigenIdentity;
Float3x3Eigen_t Float3x3Eigen( matrix_float3x3 m );

#endif /* Float3x3Eigen_h */

