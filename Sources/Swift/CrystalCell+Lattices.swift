//
//  CrystalCell+Lattices.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/10.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension CrystalCell_t {
    convenience init( _ values: [CIFTag:FloatType] ) {
        self.init( a: values[.A], b: values[.B], c: values[.C],
                   alpha: values[.Alpha], beta: values[.Beta], gamma: values[.Gamma] )
    }
}


extension CrystalCell_t {
    var isHexagonal : Bool {
        if setting == "hexagonal" {
            return true
        }
        return angleAlpha == 90 && angleBeta == 90 && angleGamma == 120
    }
}
