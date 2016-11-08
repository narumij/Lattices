//
//  Probability.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/15.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import Accelerate

private let probabilityTable : [pData] = [

    ( 0.01, 0.3389 ),
    ( 0.02, 0.4299 ),
    ( 0.03, 0.4951 ),
    ( 0.04, 0.5479 ),
    ( 0.05, 0.5932 ),

    ( 0.06, 0.6334 ),
    ( 0.07, 0.6699 ),
    ( 0.08, 0.7035 ),
    ( 0.09, 0.7349 ),
    ( 0.10, 0.7644 ),

    ( 0.11, 0.7924 ),
    ( 0.12, 0.8192 ),
    ( 0.13, 0.8447 ),
    ( 0.14, 0.8694 ),
    ( 0.15, 0.8932 ),

    ( 0.16, 0.9162 ),
    ( 0.17, 0.9386 ),
    ( 0.18, 0.9605 ),
    ( 0.19, 0.9818 ),
    ( 0.20, 1.0026 ),

    ( 0.21, 1.0230 ),
    ( 0.22, 1.0430 ),
    ( 0.23, 1.0627 ),
    ( 0.24, 1.0821 ),
    ( 0.25, 1.1012 ),

    ( 0.26, 1.1200 ),
    ( 0.27, 1.1386 ),
    ( 0.28, 1.1570 ),
    ( 0.29, 1.1751 ),
    ( 0.30, 1.1932 ),

    ( 0.31, 1.2110 ),
    ( 0.32, 1.2288 ),
    ( 0.33, 1.2464 ),
    ( 0.34, 1.2638 ),
    ( 0.35, 1.2812 ),

    ( 0.36, 1.2985 ),
    ( 0.37, 1.3158 ),
    ( 0.38, 1.3330 ),
    ( 0.39, 1.3501 ),
    ( 0.40, 1.3672 ),

    /////////////////

    ( 0.41, 1.3842 ),
    ( 0.42, 1.4013 ),
    ( 0.43, 1.4183 ),
    ( 0.44, 1.4354 ),
    ( 0.45, 1.4524 ),

    ( 0.46, 1.4695 ),
    ( 0.47, 1.4866 ),
    ( 0.48, 1.5037 ),
    ( 0.49, 1.5209 ),
    ( 0.50, 1.5382 ),

    ( 0.51, 1.5555 ),
    ( 0.52, 1.5729 ),
    ( 0.53, 1.5904 ),
    ( 0.54, 1.6080 ),
    ( 0.55, 1.6257 ),

    ( 0.56, 1.6436 ),
    ( 0.57, 1.6616 ),
    ( 0.58, 1.6797 ),
    ( 0.59, 1.6980 ),
    ( 0.60, 1.7164 ),

    ( 0.61, 1.7351 ),
    ( 0.62, 1.7540 ),
    ( 0.63, 1.7730 ),
    ( 0.64, 1.7924 ),
    ( 0.65, 1.8119 ),

    ( 0.66, 1.8318 ),
    ( 0.67, 1.8519 ),
    ( 0.68, 1.8724 ),
    ( 0.69, 1.8932 ),
    ( 0.70, 1.9144 ),

    ( 0.71, 1.9360 ),
    ( 0.72, 1.9580 ),
    ( 0.73, 1.9804 ),
    ( 0.74, 2.0034 ),
    ( 0.75, 2.0269 ),

    ( 0.76, 2.0510 ),
    ( 0.77, 2.0757 ),
    ( 0.78, 2.1012 ),
    ( 0.79, 2.1274 ),
    ( 0.80, 2.1544 ),

    /////////////////

    ( 0.81, 2.1824 ),
    ( 0.82, 2.2114 ),
    ( 0.83, 2.2416 ),
    ( 0.84, 2.2730 ),
    ( 0.85, 2.3059 ),

    ( 0.86, 2.3404 ),
    ( 0.87, 2.3767 ),
    ( 0.88, 2.4153 ),
    ( 0.89, 2.4563 ),
    ( 0.90, 2.5003 ),


    ( 0.91, 2.5478 ),
    ( 0.92, 2.5997 ),
    ( 0.93, 2.6571 ),
    ( 0.94, 2.7216 ),
    ( 0.95, 2.7955 ),

    ( 0.96, 2.8829 ),
    ( 0.97, 2.9912 ),
    ( 0.98, 3.1365 ),
    ( 0.99, 3.3682 ),
    ( 0.991, 3.4019 ),

    ( 0.992, 3.4390 ),
    ( 0.993, 3.4806 ),
    ( 0.994, 3.5280 ),
    ( 0.995, 3.5830 ),
    ( 0.996, 3.6492 ),
    
    ( 0.997, 3.7325 ),
    ( 0.998, 3.8465 ),
    ( 0.999, 4.0331 ),
    ( 0.9991, 4.0607 ),
    ( 0.9992, 4.0912 ),
    
    ( 0.9993, 4.1256 ),
    ( 0.9994, 4.1648 ),
    ( 0.9995, 4.2107 ),
    ( 0.9996, 4.2661 ),
    ( 0.9997, 4.3365 ),
    
    ( 0.9998, 4.4335 ),
    ( 0.9999, 4.5943 ),
    ( 0.99999, 5.0894 ),
    ( 0.999999, 5.5376 ),
    ( 0.9999999, 5.9503 )
]

//private let probabilityMin = 0.01
//private let probabilityMax = 0.9999999

private let probabilityMin = probabilityTable.first!.p
private let probabilityMax = probabilityTable.last!.p

private let probabilityScaleMin = probabilityTable.first!.c
private let probabilityScaleMax = probabilityTable.last!.c

private typealias pData = (p:Double,c:Double)

private func mixrate( _ a : Double, x : Double, y : Double ) -> Double {
    return ( a - x ) / ( y - x )
}

private func mix( _ x : Double, y : Double, a : Double ) -> Double {
    return x * ( 1.0 - a ) + y * a
}

func probabilityScale( from probability: Double ) -> Double {

    func lerp( a probability: Double, x: pData, y: pData) -> Double {
        let a = mixrate( probability, x: x.p, y: y.p )
        return mix( x.c, y: y.c, a : a )
    }

    if probability < probabilityMin {
        return Double.nan
    }
    if probability > probabilityMax {
        return Double.infinity
    }
    for (i,t) in probabilityTable.enumerated() {
        if t.p == probability {
            return t.c
        }
        if t.p > probability {
            return lerp( a: probability, x: probabilityTable[i-1], y: probabilityTable[i] )
        }
    }
    assert(false, "probability scale function failure.")
    return Double.infinity
}

func probabilityValue( from scale: Double ) -> Double {

    func lerp( a scale: Double, x: pData, y: pData) -> Double {
        let a = mixrate( scale, x: x.c, y: y.c )
        return mix( x.p, y: y.p, a : a )
    }

    if scale < probabilityScaleMin {
        return probabilityMin
    }
    if scale > probabilityScaleMax {
        return probabilityMax
    }
    for (i,t) in probabilityTable.enumerated() {
        if t.c == scale {
            return t.p
        }
        if t.c > scale {
            return lerp( a: scale, x: probabilityTable[i-1], y: probabilityTable[i] )
        }
    }
    assert(false, "probability scale function failure.")
    return Double.infinity
}

//func probabilityClamp( s : Double ) -> Double {
//    return max( probabilityMin, min(s, probabilityMax ) )
//}

//func probabilityValue( from scale : Double ) -> Double {
//    return mix( probabilityMin, y: probabilityMax, a: pow( s, 0.33333 ) )
//}

func ProbabilityScale( from rate : Double ) -> Double {
    return mix( probabilityScaleMin, y: probabilityScaleMax, a: pow( rate, sqrt(2.0) ) )
}

func sliderValue( from probability : Double ) -> RadiiSizeType {
    let scale = probabilityScale(from: probability)
    let a = mixrate( scale, x: probabilityScaleMin, y: probabilityScaleMax )
    return RadiiSizeType( pow( a, 1 / sqrt( 2 ) ) )
}

let ProbabilityScaleCoef : Double = 1.0 / probabilityTable.last!.c

