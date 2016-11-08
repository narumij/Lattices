//
//  PublFlag.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/23.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation

enum PublFlag_t : String {

    case yes = "yes"
    case no = "no"
    case y = "y"
    case n = "n"
    case Q = "?"

    var boolValue: Bool {
        switch self {
        case .yes:
            return true
        case .y:
            return true
        case .Q:
            return true
        default:
            break
        }
        return false
    }

}

func == ( l: PublFlag_t?, r: Bool ) -> Bool {
    let flag = l?.boolValue ?? false
    return flag == r
}

func == ( l: Bool, r: PublFlag_t? ) -> Bool {
    let flag = r?.boolValue ?? false
    return l == flag
}

func != ( l: PublFlag_t?, r: Bool ) -> Bool {
    return !(l == r)
}

func != ( l: Bool, r: PublFlag_t? ) -> Bool {
    return !(l == r)
}

extension String {
    var publFlagValue : PublFlag_t? {
        return PublFlag_t(rawValue:self)
    }
}


