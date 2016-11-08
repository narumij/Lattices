//
//  Numeric.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/23.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

struct DistanceNumeric_t {
    let source: String?
    let number: FloatType
    let uncertain: FloatType?
}

let distanceAllowable: FloatType = 0.02

// fractional aabb向け
func maximumValue( _ numeric: DistanceNumeric_t? ) -> FloatType {
//    if let numeric = numeric { return numeric.number + ( numeric.uncertain ?? distanceAllowable ) }
    if let numeric = numeric { return numeric.number + max( numeric.uncertain ?? 0, distanceAllowable ) }
    return 0
}

//extension DistanceNumeric_t {
//    func squareEqual(_ r: FloatType ) -> Bool {
//        let diff : FloatType = uncertain != nil ? uncertain! : distanceAllowable
//        return abs((number * number) - r) <= max( diff * diff, distanceAllowable * distanceAllowable )
//    }
//}

private func equal( _ l: DistanceNumeric_t, _ r: FloatType ) -> Bool {
    // 小数点2の位での四捨五入を想定している
    let diff : FloatType = l.uncertain != nil ? l.uncertain! : distanceAllowable
    return abs(l.number - r) <= max( diff, distanceAllowable )
}

func =~ ( l:DistanceNumeric_t? , r: FloatType ) -> Bool {
    if let l = l {
        return equal(l,r)
    }
    return false
}

func =~ ( l:FloatType , r: DistanceNumeric_t? ) -> Bool {
    if let r = r {
        return equal(r,l)
    }
    return false
}

func !~ ( l:DistanceNumeric_t? , r:FloatType ) -> Bool {
    return !(l =~ r)
}

func !~ ( l:FloatType , r: DistanceNumeric_t? ) -> Bool {
    return !(l =~ r)
}

extension String {
    var distanceNumericValue : DistanceNumeric_t {
//        let suq : NSNumber? = (self as NSString).cifNumericDeviationNumber()
//        let number = self.floatTypeValue
        let suq = cifNumericDeviationNumber
        let number = self.floatTypeValue
        let error : FloatType? = ( suq == nil ) ? nil : Float( suq! )
        return DistanceNumeric_t( source:self, number: number, uncertain: error )
    }
}

struct AngleNumeric_t {
    let source: String?
    let number: FloatType
    let uncertain: FloatType?
}

func =~ ( l: AngleNumeric_t, r: FloatType ) -> Bool {
    // 1の位での四捨五入を想定している
//    let diff : FloatType = l.uncertain != nil ? l.uncertain! : 0.5
    let diff : FloatType = 0.5
    return abs( l.number - r ) <= diff
}

func =~ ( l:FloatType , r: AngleNumeric_t? ) -> Bool {
    if let r = r {
        return r =~ l
    }
    return false
}

extension String {
    var angleNumericValue : AngleNumeric_t {
//        let suq : NSNumber? = (self as NSString).cifNumericDeviationNumber()
//        let number = self.floatTypeValue
//        let error : FloatType? = ( suq == nil ) ? nil : ( suq! ).floatTypeValue
        let suq = cifNumericDeviationNumber
        let number = self.floatTypeValue
        let error : FloatType? = ( suq == nil ) ? nil : Float( suq! )
        return AngleNumeric_t( source:self, number: number, uncertain: error )
    }
}




