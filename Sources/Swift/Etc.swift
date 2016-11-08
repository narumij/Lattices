//
//  Etc.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/12.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation
import CoreGraphics

func ClassName(_ obj:AnyObject?) -> String {
    if let obj = obj {
        return NSStringFromClass(type(of: obj))
    }
    return "nil"
}



