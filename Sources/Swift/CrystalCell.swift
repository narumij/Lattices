//
//  CrystalCell.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/10.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import simd

class CrystalCell_t {
    var lengthA    : FloatType { return _a     ?? 5.0 }
    var lengthB    : FloatType { return _b     ?? 5.0 }
    var lengthC    : FloatType { return _c     ?? 5.0 }
    var angleAlpha : FloatType { return _alpha ?? 90.0 }
    var angleBeta  : FloatType { return _beta  ?? 90.0 }
    var angleGamma : FloatType { return _gamma ?? 90.0 }
    fileprivate var _a    :FloatType?
    fileprivate var _b    :FloatType?
    fileprivate var _c    :FloatType?
    fileprivate var _alpha:FloatType?
    fileprivate var _beta :FloatType?
    fileprivate var _gamma:FloatType?
    var setting : String?
    init() { }
    init( a: FloatType?, b: FloatType?, c: FloatType?, alpha: FloatType?, beta: FloatType?, gamma: FloatType? ) {
        _a = a
        _b = b
        _c = c
        _alpha = alpha
        _beta = beta
        _gamma = gamma
    }

    // MARK: -

    var a: FloatType { return lengthA }
    var b: FloatType { return lengthB }
    var c: FloatType { return lengthC }
    lazy var alpha: FloatType = { self.angleAlpha.toRadian }()
    lazy var beta: FloatType = { self.angleBeta.toRadian }()
    lazy var gamma: FloatType = { self.angleGamma.toRadian }()
    lazy var aStar: FloatType = { self.b * self.c * sin(self.alpha) / self.v }()
    lazy var bStar: FloatType = { self.c * self.a * sin(self.beta) / self.v }()
    lazy var cStar: FloatType =  { self.a * self.b * sin(self.gamma) / self.v }()
    lazy var sinAlpha: FloatType = { sin( self.alpha ) }()
    lazy var cosAlpha: FloatType = { cos( self.alpha ) }()
    lazy var sinBeta:  FloatType = { sin( self.beta ) }()
    lazy var cosBeta:  FloatType = { cos( self.beta ) }()
    lazy var sinGamma: FloatType = { sin( self.gamma ) }()
    lazy var cosGamma: FloatType = { cos( self.gamma ) }()
    lazy var cosAlphaStar : FloatType = {
        return (self.cosBeta * self.cosGamma - self.cosAlpha) / (self.sinBeta * self.sinGamma)
    }()
    lazy var v : FloatType = {
        let s = sqrt( 1.0 - self.cosAlpha * self.cosAlpha - self.cosBeta * self.cosBeta - self.cosGamma * self.cosGamma
            + 2.0 * self.cosAlpha * self.cosBeta * self.cosGamma )
        return self.a * self.b * self.c * s
    }()

    lazy var aVector : Vector3 = { vector3( self.a , 0, 0 ) }()
    lazy var bVector : Vector3 = { vector3( self.b * self.cosGamma, self.b * self.sinGamma, 0) }()
    lazy var cVector : Vector3 = { vector3( self.c * self.cosBeta, -self.c * self.sinBeta * self.cosAlphaStar, 1.0 / self.cStar )
    }()
}




