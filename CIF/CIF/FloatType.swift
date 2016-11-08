//
//  FloatType.swift
//  CIF
//
//  Created by Jun Narumi on 2016/07/29.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

#if os(OSX)
    typealias FloatType = Double
#elseif os(iOS)
    typealias FloatType = Float
#endif

extension String {
//    var length : Int {
//        return self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
//    }
    var floatTypeValue: FloatType {
        #if os(OSX)
            return (self as NSString).doubleValue
        #elseif os(iOS)
            return (self as NSString).floatValue
        #endif
    }
}

