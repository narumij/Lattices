//
//  NSNumber+Lattices.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension NSNumber {
    var floatTypeValue: FloatType {
        #if os(OSX)
            return doubleValue
        #elseif os(iOS)
            return floatValue
        #endif
    }
}
