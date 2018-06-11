//
//  String+Lattices.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

extension String {
    func head( _ count: Int ) -> String {
        let idx = self.index(self.startIndex, offsetBy: count)
        return self.substring(to: idx)
    }
    func tail( _ count: Int ) -> String {
        let idx = self.index(self.startIndex, offsetBy: count)
        return self.substring(from: idx)
    }
}

extension String {
    var length : Int {
        return self.lengthOfBytes(using: String.Encoding.utf8)
    }
    var floatTypeValue: FloatType {
        #if os(OSX)
            return (self as NSString).doubleValue
        #elseif os(iOS)
            return (self as NSString).floatValue
        #endif
    }
}
